#!/usr/bin/env python3

import sys

from io import StringIO
from pprint import pprint


CHARS_COMMAND = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_*"
CHARS_SPECIAL = "\\{}[]$%"
TEXT_ENVIRONMENTS = ('quote', 'itemize', 'enumerate')
REPLACEMENTS = [
    ('``', '\N{LEFT DOUBLE QUOTATION MARK}'),
    ("''", '\N{RIGHT DOUBLE QUOTATION MARK}'),
    ('`', '\N{LEFT SINGLE QUOTATION MARK}'),
    ("'", '\N{RIGHT SINGLE QUOTATION MARK}'),
    ("---", '\N{EM DASH}'),
    ("--", '\N{EN DASH}'),
]


def tokenize(data):
    it = iter(data)
    peek = None
    try:
        while True:
            if peek is None:
                try:
                    ch = next(it)
                except StopIteration:
                    break
            else:
                ch, peek = peek, None
            if ch == '\\':
                ch = next(it)
                if ch in CHARS_COMMAND:
                    buf = ch
                    for ch in it:
                        if ch not in CHARS_COMMAND:
                            peek = ch
                            break
                        buf += ch
                    yield 'command', buf
                elif ch in '()':
                    yield 'bracket', ch
                else:
                    yield 'escape', ch
            elif ch in '{}':
                yield 'brace', ch
            elif ch in '[]':
                yield 'square', ch
            elif ch == '$':
                yield 'dollar', ch
            elif ch == '%':
                buf = ""
                for ch in it:
                    if ch == '\n':
                        break
                    buf += ch
                yield 'comment', buf
            elif ch in CHARS_SPECIAL:
                raise ValueError("unreachable")
            else:
                buf = ch
                for ch in it:
                    if ch in CHARS_SPECIAL:
                        peek = ch
                        break
                    buf += ch
                yield 'string', buf
    except StopIteration:
        raise ValueError("unexpected EOF")


def parse(data):
    stack = []
    node = []
    args = None
    in_dollar = False

    it = tokenize(data)
    peek = None
    try:
        while True:
            if peek is None:
                try:
                    token = next(it)
                except StopIteration:
                    break
            else:
                token, peek = peek, None
            if token[0] in ('string', 'escape', 'comment'):
                node.append(token)
            elif token[0] == 'command':
                args = ([], [])
                node.append(('command', token[1], args))
            elif token[0] in ['brace', 'square']:
                if token[1] in ('{', '['):
                    if args is None:
                        args = ([], [])
                        node.append(('command', None, args))
                    stack.append((token[1], node, args))
                    node = []
                    if token[0] == 'brace':
                        args[0].append(node)
                    elif token[0] == 'square':
                        args[1].append(node)
                    else:
                        raise ValueError("unreachable")
                    args = None
                elif token[1] == '}':
                    opener, node, args = stack.pop()
                    if opener != '{':
                        raise ValueError("unmatched " + repr(opener))
                elif token[1] == ']':
                    opener, node, args = stack.pop()
                    if opener != '[':
                        raise ValueError("unmatched " + repr(opener))
                else:
                    raise ValueError("unreachable")
            elif token[0] == 'dollar':
                if not in_dollar:
                    stack.append(('$', node, args))
                    old_node = node
                    node, args = [], None
                    old_node.append(node)
                else:
                    opener, node, args = stack.pop()
                    if opener != '$':
                        raise ValueError("unmatched " + repr(opener))
                in_dollar = not in_dollar
            elif token[0] == 'bracket':
                if token[1] == '(':
                    stack.append(('(', node, args))
                    old_node = node
                    node, args = [], None
                    old_node.append(('math', node))
                elif token[1] == ')':
                    opener, node, args = stack.pop()
                    if opener != '(':
                        raise ValueError("unmatched " + repr(opener))
                else:
                    raise ValueError("unreachable")
            else:
                raise NotImplementedError(token, node)
    except StopIteration:
        raise ValueError("unexpected EOF")

    if stack:
        raise ValueError("unclosed " + repr(stack[-1][0]))
    return node


def unescape(ch):
    if ch == '\\':
        return '\n'
    else:
        return ch


def flatten_arg(nodes):
    result = ""
    for node in nodes:
        if node[0] == 'string':
            result += node[1]
        elif node[0] == 'escape':
            result += unescape(node[1])
        elif node[0] == 'command':
            print("debug: ignoring command " + repr(node[1]) + " in header", file=sys.stderr)
        elif node[0] in ('math', 'comment'):
            pass
        else:
            raise NotImplementedError(node)
    return result


def handle_node(state, node):
    section = state['section']
    if node[0] == 'string':
        if section[5] == 0:
            section[3] += node[1]
    elif node[0] == 'escape':
        if section[5] == 0:
            section[3] += unescape(node[1])
    elif node[0] == 'command':
        command = node[1].replace('*', '')
        if command == 'part' or command.endswith('section'):
            if command == 'part':
                subs = -1
            else:
                subs, cmd = 0, command
                while cmd.startswith('sub'):
                    subs += 1
                    cmd = cmd[3:]
                if cmd != 'section':
                    raise NotImplementedError(node)
            while subs <= section[2]:
                section = section[1]
            header = flatten_arg(node[2][0][0])
            subsection = [header, section, subs, header + '\n', [], 0]
            section[4].append(subsection)
            state['section'] = subsection
        elif command == 'begin':
            kind = flatten_arg(node[2][0][0])
            if kind not in TEXT_ENVIRONMENTS:
                section[5] += 1
        elif command == 'end':
            kind = flatten_arg(node[2][0][0])
            if kind not in TEXT_ENVIRONMENTS:
                section[5] -= 1
                if section[5] < 0:
                    raise ValueError("trying to close unopened section")
        elif section[5] == 0:
            print("debug: ignoring command " + repr(node[1]), file=sys.stderr)
    elif node[0] in ('math', 'comment'):
        pass
    else:
        raise NotImplementedError(node)


def handle_ast(ast):
    root = [None, None, -2, "", [], 0]
    state = {'section': root}
    it = iter(ast)
    for node in it:
        if node[0] == 'command' and node[1].replace('*', '') == 'begin':
            if flatten_arg(node[2][0][0]).strip() == 'document':
                break
    for node in it:
        if node[0] == 'command' and node[1].replace('*', '') == 'end':
            if flatten_arg(node[2][0][0]).strip() == 'document':
                break
        handle_node(state, node)
    return root


def apply_replacements(text):
    for a, b in REPLACEMENTS:
        text = text.replace(a, b)
    return text


def handle_section(section):
    header, parent, subs, body, children, begins = section
    body = apply_replacements(body)
    assert begins == 0
    parts = body.split()
    child_counts = [handle_section(child) for child in children]
    counts = {
        'non-space': sum(len(part) for part in parts),
        'space': (len(parts) or 1) - 1,
    }
    for k, v in list(counts.items()):
        counts['total ' + k] = v + sum(c['total ' + k] for h, s, c in child_counts)
    counts['children'] = child_counts
    return (header, subs, counts)


def pretty_print(counts, last=True):
    header, subs, counts = counts
    indent = '  ' * (subs + 2)
    if header:
        print(indent + '#', header)
        print()
    print(indent + "Spaces:", counts['space'])
    print(indent + "Non-spaces:", counts['non-space'])
    print(indent + "Total spaces:", counts['total space'])
    print(indent + "Total non-spaces:", counts['total non-space'])
    children = counts['children']
    if children:
        print()
        for child in children[:-1]:
            pretty_print(child, False)
        pretty_print(children[-1], last)
    elif not last:
        print()


def extract_text(section):
    header, parent, subs, body, children, begins = section
    body = apply_replacements(body)
    indent = '  ' * (subs + 2)
    if header:
        print(indent + '#', header)
        print()
        body = body.partition('\n')[2]
    body = ' '.join(body.split())
    if body:
        print(indent + body)
        print()
    for child in children:
        extract_text(child)


if __name__ == '__main__':
    import unicodedata

    data = sys.stdin.read()
    print("debug: data is NFC:", unicodedata.normalize('NFC', data) == data, file=sys.stderr)
    section = handle_ast(parse(data))

    if len(sys.argv) < 2:
        arg = '--count'
    elif len(sys.argv) == 2:
        arg = sys.argv[1]
    else:
        arg = None
    if arg in ('-c', '--count'):
        counts = handle_section(section)
        pretty_print(counts)
    elif arg in ('-x', '--extract'):
        extract_text(section)
    else:
        print("usage: python3 latex_wc.py [--extract|--count]", file=sys.stderr)
        exit(1)
