function chkinput(x)
% Check for valid input signal

if isempty(x) || issparse(x) || ~isreal(x),
    error(message('signal:cceps:invalidInput', 'X'));
end