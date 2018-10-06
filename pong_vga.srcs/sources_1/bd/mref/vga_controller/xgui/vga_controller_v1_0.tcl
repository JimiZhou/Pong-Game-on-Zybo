# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "h_bp" -parent ${Page_0}
  ipgui::add_param $IPINST -name "h_fp" -parent ${Page_0}
  ipgui::add_param $IPINST -name "h_pixels" -parent ${Page_0}
  ipgui::add_param $IPINST -name "h_pulse" -parent ${Page_0}
  ipgui::add_param $IPINST -name "v_bp" -parent ${Page_0}
  ipgui::add_param $IPINST -name "v_fp" -parent ${Page_0}
  ipgui::add_param $IPINST -name "v_pixels" -parent ${Page_0}
  ipgui::add_param $IPINST -name "v_pulse" -parent ${Page_0}


}

proc update_PARAM_VALUE.h_bp { PARAM_VALUE.h_bp } {
	# Procedure called to update h_bp when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.h_bp { PARAM_VALUE.h_bp } {
	# Procedure called to validate h_bp
	return true
}

proc update_PARAM_VALUE.h_fp { PARAM_VALUE.h_fp } {
	# Procedure called to update h_fp when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.h_fp { PARAM_VALUE.h_fp } {
	# Procedure called to validate h_fp
	return true
}

proc update_PARAM_VALUE.h_pixels { PARAM_VALUE.h_pixels } {
	# Procedure called to update h_pixels when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.h_pixels { PARAM_VALUE.h_pixels } {
	# Procedure called to validate h_pixels
	return true
}

proc update_PARAM_VALUE.h_pulse { PARAM_VALUE.h_pulse } {
	# Procedure called to update h_pulse when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.h_pulse { PARAM_VALUE.h_pulse } {
	# Procedure called to validate h_pulse
	return true
}

proc update_PARAM_VALUE.v_bp { PARAM_VALUE.v_bp } {
	# Procedure called to update v_bp when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.v_bp { PARAM_VALUE.v_bp } {
	# Procedure called to validate v_bp
	return true
}

proc update_PARAM_VALUE.v_fp { PARAM_VALUE.v_fp } {
	# Procedure called to update v_fp when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.v_fp { PARAM_VALUE.v_fp } {
	# Procedure called to validate v_fp
	return true
}

proc update_PARAM_VALUE.v_pixels { PARAM_VALUE.v_pixels } {
	# Procedure called to update v_pixels when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.v_pixels { PARAM_VALUE.v_pixels } {
	# Procedure called to validate v_pixels
	return true
}

proc update_PARAM_VALUE.v_pulse { PARAM_VALUE.v_pulse } {
	# Procedure called to update v_pulse when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.v_pulse { PARAM_VALUE.v_pulse } {
	# Procedure called to validate v_pulse
	return true
}


proc update_MODELPARAM_VALUE.h_pulse { MODELPARAM_VALUE.h_pulse PARAM_VALUE.h_pulse } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.h_pulse}] ${MODELPARAM_VALUE.h_pulse}
}

proc update_MODELPARAM_VALUE.h_bp { MODELPARAM_VALUE.h_bp PARAM_VALUE.h_bp } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.h_bp}] ${MODELPARAM_VALUE.h_bp}
}

proc update_MODELPARAM_VALUE.h_pixels { MODELPARAM_VALUE.h_pixels PARAM_VALUE.h_pixels } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.h_pixels}] ${MODELPARAM_VALUE.h_pixels}
}

proc update_MODELPARAM_VALUE.h_fp { MODELPARAM_VALUE.h_fp PARAM_VALUE.h_fp } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.h_fp}] ${MODELPARAM_VALUE.h_fp}
}

proc update_MODELPARAM_VALUE.v_pulse { MODELPARAM_VALUE.v_pulse PARAM_VALUE.v_pulse } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.v_pulse}] ${MODELPARAM_VALUE.v_pulse}
}

proc update_MODELPARAM_VALUE.v_bp { MODELPARAM_VALUE.v_bp PARAM_VALUE.v_bp } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.v_bp}] ${MODELPARAM_VALUE.v_bp}
}

proc update_MODELPARAM_VALUE.v_pixels { MODELPARAM_VALUE.v_pixels PARAM_VALUE.v_pixels } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.v_pixels}] ${MODELPARAM_VALUE.v_pixels}
}

proc update_MODELPARAM_VALUE.v_fp { MODELPARAM_VALUE.v_fp PARAM_VALUE.v_fp } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.v_fp}] ${MODELPARAM_VALUE.v_fp}
}

