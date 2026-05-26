onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib uav_sar_opt

do {wave.do}

view wave
view structure
view signals

do {uav_sar.udo}

run -all

quit -force
