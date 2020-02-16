case g_data_samples_exp is
	when 2 =>
		out_cos := (
			to_signed(255, 9), to_signed(0, 9), 
		);
	when 3 =>
		out_cos := (
			to_signed(255, 9), to_signed(180, 9), to_signed(0, 9), to_signed(-180, 9), 
		);
	when 4 =>
		out_cos := (
			to_signed(255, 9), to_signed(236, 9), to_signed(180, 9), to_signed(98, 9), to_signed(0, 9), to_signed(-98, 9), to_signed(-180, 9), to_signed(-236, 9), 
		);
	when 5 =>
		out_cos := (
			to_signed(255, 9), to_signed(250, 9), to_signed(236, 9), to_signed(212, 9), to_signed(180, 9), to_signed(142, 9), to_signed(98, 9), to_signed(50, 9), to_signed(0, 9), to_signed(-50, 9), to_signed(-98, 9), to_signed(-142, 9), to_signed(-180, 9), to_signed(-212, 9), to_signed(-236, 9), to_signed(-250, 9), 
		);
	when 6 =>
		out_cos := (
			to_signed(255, 9), to_signed(254, 9), to_signed(250, 9), to_signed(244, 9), to_signed(236, 9), to_signed(225, 9), to_signed(212, 9), to_signed(197, 9), to_signed(180, 9), to_signed(162, 9), to_signed(142, 9), to_signed(120, 9), to_signed(98, 9), to_signed(74, 9), to_signed(50, 9), to_signed(25, 9), to_signed(0, 9), to_signed(-25, 9), to_signed(-50, 9), to_signed(-74, 9), to_signed(-98, 9), to_signed(-120, 9), to_signed(-142, 9), to_signed(-162, 9), to_signed(-180, 9), to_signed(-197, 9), to_signed(-212, 9), to_signed(-225, 9), to_signed(-236, 9), to_signed(-244, 9), to_signed(-250, 9), to_signed(-254, 9), 
		);
	when 7 =>
		out_cos := (
			to_signed(255, 9), to_signed(255, 9), to_signed(254, 9), to_signed(252, 9), to_signed(250, 9), to_signed(247, 9), to_signed(244, 9), to_signed(240, 9), to_signed(236, 9), to_signed(231, 9), to_signed(225, 9), to_signed(219, 9), to_signed(212, 9), to_signed(205, 9), to_signed(197, 9), to_signed(189, 9), to_signed(180, 9), to_signed(171, 9), to_signed(162, 9), to_signed(152, 9), to_signed(142, 9), to_signed(131, 9), to_signed(120, 9), to_signed(109, 9), to_signed(98, 9), to_signed(86, 9), to_signed(74, 9), to_signed(62, 9), to_signed(50, 9), to_signed(37, 9), to_signed(25, 9), to_signed(13, 9), to_signed(0, 9), to_signed(-13, 9), to_signed(-25, 9), to_signed(-37, 9), to_signed(-50, 9), to_signed(-62, 9), to_signed(-74, 9), to_signed(-86, 9), to_signed(-98, 9), to_signed(-109, 9), to_signed(-120, 9), to_signed(-131, 9), to_signed(-142, 9), to_signed(-152, 9), to_signed(-162, 9), to_signed(-171, 9), to_signed(-180, 9), to_signed(-189, 9), to_signed(-197, 9), to_signed(-205, 9), to_signed(-212, 9), to_signed(-219, 9), to_signed(-225, 9), to_signed(-231, 9), to_signed(-236, 9), to_signed(-240, 9), to_signed(-244, 9), to_signed(-247, 9), to_signed(-250, 9), to_signed(-252, 9), to_signed(-254, 9), to_signed(-255, 9), 
		);
	when 8 =>
		out_cos := (
			to_signed(255, 9), to_signed(255, 9), to_signed(255, 9), to_signed(254, 9), to_signed(254, 9), to_signed(253, 9), to_signed(252, 9), to_signed(251, 9), to_signed(250, 9), to_signed(249, 9), to_signed(247, 9), to_signed(246, 9), to_signed(244, 9), to_signed(242, 9), to_signed(240, 9), to_signed(238, 9), to_signed(236, 9), to_signed(233, 9), to_signed(231, 9), to_signed(228, 9), to_signed(225, 9), to_signed(222, 9), to_signed(219, 9), to_signed(215, 9), to_signed(212, 9), to_signed(208, 9), to_signed(205, 9), to_signed(201, 9), to_signed(197, 9), to_signed(193, 9), to_signed(189, 9), to_signed(185, 9), to_signed(180, 9), to_signed(176, 9), to_signed(171, 9), to_signed(167, 9), to_signed(162, 9), to_signed(157, 9), to_signed(152, 9), to_signed(147, 9), to_signed(142, 9), to_signed(136, 9), to_signed(131, 9), to_signed(126, 9), to_signed(120, 9), to_signed(115, 9), to_signed(109, 9), to_signed(103, 9), to_signed(98, 9), to_signed(92, 9), to_signed(86, 9), to_signed(80, 9), to_signed(74, 9), to_signed(68, 9), to_signed(62, 9), to_signed(56, 9), to_signed(50, 9), to_signed(44, 9), to_signed(37, 9), to_signed(31, 9), to_signed(25, 9), to_signed(19, 9), to_signed(13, 9), to_signed(6, 9), to_signed(0, 9), to_signed(-6, 9), to_signed(-13, 9), to_signed(-19, 9), to_signed(-25, 9), to_signed(-31, 9), to_signed(-37, 9), to_signed(-44, 9), to_signed(-50, 9), to_signed(-56, 9), to_signed(-62, 9), to_signed(-68, 9), to_signed(-74, 9), to_signed(-80, 9), to_signed(-86, 9), to_signed(-92, 9), to_signed(-98, 9), to_signed(-103, 9), to_signed(-109, 9), to_signed(-115, 9), to_signed(-120, 9), to_signed(-126, 9), to_signed(-131, 9), to_signed(-136, 9), to_signed(-142, 9), to_signed(-147, 9), to_signed(-152, 9), to_signed(-157, 9), to_signed(-162, 9), to_signed(-167, 9), to_signed(-171, 9), to_signed(-176, 9), to_signed(-180, 9), to_signed(-185, 9), to_signed(-189, 9), to_signed(-193, 9), to_signed(-197, 9), to_signed(-201, 9), to_signed(-205, 9), to_signed(-208, 9), to_signed(-212, 9), to_signed(-215, 9), to_signed(-219, 9), to_signed(-222, 9), to_signed(-225, 9), to_signed(-228, 9), to_signed(-231, 9), to_signed(-233, 9), to_signed(-236, 9), to_signed(-238, 9), to_signed(-240, 9), to_signed(-242, 9), to_signed(-244, 9), to_signed(-246, 9), to_signed(-247, 9), to_signed(-249, 9), to_signed(-250, 9), to_signed(-251, 9), to_signed(-252, 9), to_signed(-253, 9), to_signed(-254, 9), to_signed(-254, 9), to_signed(-255, 9), to_signed(-255, 9), 
		);
	when others =>
		out_cos := (others => "011111111");
end case;