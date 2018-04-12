function cal = cal_struct(cal_file, cal_dir, bits_sharp)
    % cal = cal_struct(cal_file, cal_dir, bits_sharp)
    if nargin < 3
        bits_sharp = 0;
    end
    import white.*
    [T_xyz, S_xyz] = gen.cie1931CMFs();
    try
        cal = LoadCalFile(cal_file, [], cal_dir);

    catch
        white.stim.cleanup();
        error('Cal file not found.')
    end
    
    cal = SetSensorColorSpace(cal, T_xyz, S_xyz);
    cal = SetGammaMethod(cal, 0);
    
    cal.bits_sharp = bits_sharp;

end