function cal = cal_struct(cal_file, cal_dir)
    import white.*
    [T_xyz, S_xyz] = gen.cie1931CMFs();
    cal = LoadCalFile(cal_file, [], cal_dir);
    
    cal = SetSensorColorSpace(cal, T_xyz, S_xyz);
    cal = SetGammaMethod(cal,0);

end