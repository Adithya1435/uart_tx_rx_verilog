transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/kali-adi/Documents/Eyantra_Eco_Mender/Task2/Task2a/t2a_uart/uart_rx/code {/home/kali-adi/Documents/Eyantra_Eco_Mender/Task2/Task2a/t2a_uart/uart_rx/code/uart_rx.v}

vlog -vlog01compat -work work +incdir+/home/kali-adi/Documents/Eyantra_Eco_Mender/Task2/Task2a/t2a_uart/uart_rx/.test {/home/kali-adi/Documents/Eyantra_Eco_Mender/Task2/Task2a/t2a_uart/uart_rx/.test/tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb

add wave *
view structure
view signals
run 550000 ns
