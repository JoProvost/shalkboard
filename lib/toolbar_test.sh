#!/usr/bin/env bash
trap 'echo -e "\e[31mFailure at $0:$LINENO"; tail -n +$((LINENO-1)) $0 | sed "/^$/q;s/^/| /g" | sed "/^$/d"; echo -e "\e[0m"; exit 1' ERR

pushd "$(dirname -- "$0")" >/dev/null || exit 1
. terminal.sh
. buffer.sh
. toolbar.sh
popd >/dev/null || true



drawing_the_toolbar() {
  on_toolbar_event() {
    toolbar_start ||
      toolbar_line_start ||
        toolbar_button "first" first_action ${first_selected-false} ||
        toolbar_button "second" second_action ${second_selected-false} ||
        toolbar_label "label:" ||
        toolbar_button "third" third_action ${third_selected-false} ||
      toolbar_line_end ||
    toolbar_end
  }
  first_action() { echo first_action >&2 ; }
  second_action() { echo second_action >&2 ; }
  third_action() { echo third_action >&2 ; }
  on_terminal_write() {  buffer write "$@"; }
  buffer clear
  toolbar_draw >/dev/null
}



drawing_the_toolbar # Displays buttons and labels
diff <(buffer save) <(
echo "┌───────┐┌────────┐        ┌───────┐ "
echo "│ first ││ second │ label: │ third │ "
echo "└───────┘└────────┘        └───────┘ "
)



second_selected=true drawing_the_toolbar # Shows selected buttons
diff <(buffer save) <(
echo "┌───────┐┏━━━━━━━━┓        ┌───────┐ "
echo "│ first │┃ second ┃ label: │ third │ "
echo "└───────┘┗━━━━━━━━┛        └───────┘ "
)



# Performs button action when clicking
diff <(toolbar_click 15 2 2>&1 >/dev/null) <(
echo "second_action"
)



# Returns 0 when a button was clicked
if toolbar_click 15 2 >/dev/null 2>&1; then true; else false; fi



# Returns 1 when no button was clicked
if toolbar_click 15 4 >/dev/null 2>&1; then false; else true; fi



# Clicking on the label does nothing
diff <(toolbar_click 23 2 2>&1 >/dev/null) <(:;)



drawing_a_two_lines_toolbar() {
  on_toolbar_event() {
    toolbar_start ||
      toolbar_line_start ||
        toolbar_button "first" first_action ${first_selected-false} ||
        toolbar_button "second" second_action ${second_selected-false} ||
        toolbar_label "label:" ||
        toolbar_button "third" third_action ${third_selected-false} ||
      toolbar_line_end ||
      toolbar_line_start ||
        toolbar_button "fourth" fourth_action ${fourth_selected-false} ||
        toolbar_button "fifth" fifth_action ${fifth_selected-false} ||
        toolbar_label "other label:" ||
        toolbar_button "sixth" sixth_action ${sixth_selected-false} ||
      toolbar_line_end ||
    toolbar_end
  }
  first_action() { echo first_action >&2 ; }
  second_action() { echo second_action >&2 ; }
  third_action() { echo third_action >&2 ; }
  fourth_action() { echo fourth_action >&2 ; }
  fifth_action() { echo fifth_action >&2 ; }
  sixth_action() { echo sixth_action >&2 ; }
  on_terminal_write() {  buffer write "$@"; }
  buffer clear
  second_selected=false
  toolbar_draw >/dev/null
}



drawing_a_two_lines_toolbar # Displays multiple lines
diff <(buffer save) <(
echo "┌───────┐┌────────┐        ┌───────┐ "
echo "│ first ││ second │ label: │ third │ "
echo "└───────┘└────────┘        └───────┘ "
echo "┌────────┐┌───────┐              ┌───────┐ "
echo "│ fourth ││ fifth │ other label: │ sixth │ "
echo "└────────┘└───────┘              └───────┘ "
)



fourth_selected=true sixth_selected=true drawing_a_two_lines_toolbar # Shows selected buttons
diff <(buffer save) <(
echo "┌───────┐┌────────┐        ┌───────┐ "
echo "│ first ││ second │ label: │ third │ "
echo "└───────┘└────────┘        └───────┘ "
echo "┏━━━━━━━━┓┌───────┐              ┏━━━━━━━┓ "
echo "┃ fourth ┃│ fifth │ other label: ┃ sixth ┃ "
echo "┗━━━━━━━━┛└───────┘              ┗━━━━━━━┛ "
)



# Performs button action when clicking on the second line
diff <(toolbar_click 38 5 2>&1 >/dev/null) <(
echo "sixth_action"
)

