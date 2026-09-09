line_buffer_inst : line_buffer PORT MAP (
		data	 => data_sig,
		wraddress	 => wraddress_sig,
		rdaddress	 => rdaddress_sig,
		wren	 => wren_sig,
		rden	 => rden_sig,
		wrclock	 => wrclock_sig,
		rdclock	 => rdclock_sig,
		q	 => q_sig
	);
