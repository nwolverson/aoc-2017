import re

def parseBranch():
    branch = int(re.search(r"If.*is ([01]):", lines.pop()).group(1))
    val = int(re.search(r"value ([01])", lines.pop()).group(1))
    dirn = re.search(r"to the (left|right)", lines.pop()).group(1)
    state = re.search(r"with state (.*)\.", lines.pop()).group(1)
    return branch, (val, dirn, state)
    

def parseState():
    if len(lines) > 0:
        lines.pop()
    state = re.search(r"In state (.*):", lines.pop()).group(1)
    v1, act1 = parseBranch()
    v2, act2 = parseBranch()
    return state, {v1: act1, v2: act2}

lines = [line.rstrip('\n') for line in open('input.txt')]
lines.reverse()

state = re.match(r"Begin in state (.*)\.", lines.pop()).group(1)
steps = int(re.match(r"Perform.* after ([0-9]+) steps.", lines.pop()).group(1))

states = {}
while len(lines) > 0:
    st, actions = parseState()
    states[st] = actions

tape = {}
slot = 0
def tapeval(ix):
    if ix in tape:
        return tape[ix]
    else:
        return 0

def go(dir):
    global slot
    if dir == "left":
        slot = slot - 1
    else:
        slot = slot + 1

def performStep():
    global state
    val = tapeval(slot)
    newVal, newDir, newState = states[state][val]
    tape[slot] = newVal
    go(newDir)
    state = newState

step = 0
while step < steps:
    performStep()
    step = step + 1

print sum(tape.values())