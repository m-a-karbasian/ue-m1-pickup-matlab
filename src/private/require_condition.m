function require_condition(condition, message)
%REQUIRE_CONDITION Reject inconsistent inputs before calculation.
if ~condition
    error('uem1:InvalidInput', '%s', message);
end
end
