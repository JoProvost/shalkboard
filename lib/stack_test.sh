#!/usr/bin/env bash
trap 'echo -e "\e[31mFailure at $0:$LINENO"; tail -n +$((LINENO-1)) $0 | sed "/^$/q;s/^/| /g" | sed "/^$/d"; echo -e "\e[0m"; exit 1' ERR

pushd "$(dirname -- "$0")" >/dev/null || exit 1
. ./stack.sh
popd >/dev/null || true

on_before_stack_undo() { echo on_before_stack_undo "$@"; }
on_after_stack_undo() { echo on_after_stack_undo; stack replay; }
on_after_stack_rollback() { echo on_after_stack_rollback; stack replay; }


# stack push executes tasks as they are provided
diff <(stack push echo some pushed task) - <<EQUALS
some pushed task
EQUALS

# stack replace executes tasks as they are provided
diff <(stack replace echo some replaced task) - <<EQUALS
some replaced task
EQUALS

# stack alter executes tasks as they are provided
diff <(stack alter echo some altered task) - <<EQUALS
some altered task
EQUALS


stack clear
stack push echo first pushed task > /dev/null
stack push echo second pushed task > /dev/null
stack push echo third pushed task > /dev/null
stack replace echo replaced third task > /dev/null
stack push echo fourth pushed task > /dev/null
stack alter echo altered fourth task > /dev/null

# stack replay replays tasks pushed, replaced and altered
diff <(stack replay) - <<EQUALS
first pushed task
second pushed task
replaced third task
altered fourth task
EQUALS


stack clear
stack push echo first pushed task > /dev/null
stack push echo second pushed task > /dev/null
stack push echo third pushed task > /dev/null

#stack undo undoes task pushed, reporting the undone task
diff <(stack undo) - <<EQUALS
on_before_stack_undo echo third pushed task
on_after_stack_undo
first pushed task
second pushed task
EQUALS


stack clear
stack push echo first pushed task > /dev/null
stack push echo second pushed task > /dev/null
stack replace echo replacing second pushed task > /dev/null
stack replace echo replacing the replaced task > /dev/null

# There is an history on replaced tasks, undoing will recover the replaced task
diff <(stack undo) - <<EQUALS
on_before_stack_undo echo replacing the replaced task
on_after_stack_undo
first pushed task
replacing second pushed task
EQUALS


stack clear
stack push echo first pushed task > /dev/null
stack push echo second pushed task > /dev/null
stack alter echo altering second pushed task > /dev/null
stack alter echo altering the replaced task > /dev/null

# There is no history on altered tasks, undoing will simply discard the altered task
diff <(stack undo) - <<EQUALS
on_before_stack_undo echo altering the replaced task
on_after_stack_undo
first pushed task
EQUALS


stack clear
stack push echo first pushed task > /dev/null
stack push echo second pushed task > /dev/null
stack commit

stack push echo third pushed task > /dev/null
stack push echo fourth pushed task > /dev/null

# There is no history on altered tasks, undoing will simply discard the altered task
diff <(stack rollback) - <<EQUALS
on_after_stack_rollback
first pushed task
second pushed task
EQUALS
