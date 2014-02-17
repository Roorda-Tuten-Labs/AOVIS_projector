function [first, second] = gen_hue_order()

    randomize = Randi(2);
    if randomize
        first = 'blue';
        second = 'yellow';
    else
        first = 'yellow';
        second = 'blue';
    end

end