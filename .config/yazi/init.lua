-- Relative line numbers in the file list, matching ranger's
-- `set line_numbers relative` + `relative_current_zero false`
-- (current line shows its absolute number, others relative).
require("relative-motions"):setup({ show_numbers = "relative_absolute" })
