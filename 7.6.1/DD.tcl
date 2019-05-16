# ==================================================================
# Define options
# ===================================================================
set opt(chan)		Channel/WirelessChannel
set opt(prop)		Propagation/TwoRayGround
set opt(netif)	Phy/WirelessPhy
set opt(mac)		Mac/802_11
set opt(ifq)		Queue/DropTail/PriQueue
set opt(ll)		LL
set opt(ant)         Antenna/OmniAntenna
set opt(filters)     GradientFilter          ;# old name for twophasepull filter
set opt(x)		670	                  ;# X dimension of the topography
set opt(y)		670                      ;# Y dimension of the topography
set opt(ifqlen)	50	                  ;# max packet in ifq
set opt(nn)		10	                  ;# number of nodes
set opt(sndr)        1                       ;# no of senders
set opt(rcvr)        4                       ;# no of recvrs
set opt(seed)		0.0
set opt(stop)		100	                  ;# simulation time
set opt(tr)		"DD.tr"	           ;# trace file
set opt(nam)         "DD.nam"             ;# nam file
set opt(adhocRouting)   Directed_Diffusion

# ==================================================================

LL set mindelay_		50us
LL set delay_			25us
LL set bandwidth_		0	   ;# not used

Queue/DropTail/PriQueue set Prefer_Routing_Protocols    1

# unity gain, omni-directional antennas
# set up the antennas to be centered in the node and 1.5 meters above it
Antenna/OmniAntenna set X_ 0
Antenna/OmniAntenna set Y_ 0
Antenna/OmniAntenna set Z_ 1.5
Antenna/OmniAntenna set Gt_ 1.0
Antenna/OmniAntenna set Gr_ 1.0

# Initialize the SharedMedia interface with parameters to make
# it work like the 914MHz Lucent WaveLAN DSSS radio interface
Phy/WirelessPhy set CPThresh_ 10.0
Phy/WirelessPhy set CSThresh_ 1.559e-11
Phy/WirelessPhy set RXThresh_ 3.652e-10
Phy/WirelessPhy set Rb_ 2*1e6
Phy/WirelessPhy set Pt_ 0.2818
Phy/WirelessPhy set freq_ 914e+6 
Phy/WirelessPhy set L_ 1.0

# ==================================================================
# Main Program
# =================================================================

#
# Initialize Global Variables
#

set ns_	[new Simulator] 
set topo	[new Topography]

set tracefd	[open $opt(tr) w]
$ns_ use-newtrace
$ns_ trace-all $tracefd

set nf [open $opt(nam) w]
$ns_ namtrace-all-wireless $nf $opt(x) $opt(y)

#$ns_ use-newtrace

$topo load_flatgrid $opt(x) $opt(y)

set god_ [create-god $opt(nn)]

#global node setting

$ns_ node-config -adhocRouting $opt(adhocRouting) \
		 -llType $opt(ll) \
		 -macType $opt(mac) \
		 -ifqType $opt(ifq) \
		 -ifqLen $opt(ifqlen) \
		 -antType $opt(ant) \
		 -propType $opt(prop) \
		 -phyType $opt(netif) \
		 -channelType $opt(chan) \
		 -topoInstance $topo \
               -diffusionFilter $opt(filters) \
		 -agentTrace ON \
               -routerTrace ON \
               -macTrace ON


for {set i 0} {$i < $opt(nn) } {incr i} {
	 set node_($i) [$ns_ node $i]
        $node_($i) color black
	 $node_($i) random-motion 0		;# disable random motion
        $god_ new_node $node_($i)
}

puts "Loading connection pattern..."


$node_(0) set X_ 18
$node_(0) set Y_ 331
$node_(0) set Z_ 0
$node_(1) set X_ 11
$node_(1) set Y_ 36
$node_(1) set Z_ 0
$node_(2) set X_ 224
$node_(2) set Y_ 20
$node_(2) set Z_ 0
$node_(3) set X_ 158
$node_(3) set Y_ 139
$node_(3) set Z_ 0
$node_(4) set X_ 101
$node_(4) set Y_ 147
$node_(4) set Z_ 0
$node_(5) set X_ 321
$node_(5) set Y_ 382
$node_(5) set Z_ 0
$node_(6) set X_ 149
$node_(6) set Y_ 314
$node_(6) set Z_ 0
$node_(7) set X_ 381
$node_(7) set Y_ 78
$node_(7) set Z_ 0
$node_(8) set X_ 113
$node_(8) set Y_ 400
$node_(8) set Z_ 0
$node_(9) set X_ 258
$node_(9) set Y_ 113
$node_(9) set Z_ 0


# 1 ping sender
for {set i 0} {$i < $opt(sndr)} {incr i} {
    set src_($i) [new Application/DiffApp/PingSender/TPP]
    $ns_ attach-diffapp $node_([expr $i + 2]) $src_($i)
    $ns_ at [expr 0.12 * [expr 1+$i]] "$src_($i) publish"
}

# 4 ping receivers
for {set i 0} {$i < $opt(rcvr)} {incr i} {
    set snk_($i) [new Application/DiffApp/PingReceiver/TPP]
    $ns_ attach-diffapp $node_([expr $opt(nn)-1 -$i]) $snk_($i)
    $ns_ at [expr 1.15*[expr 1+$i]] "$snk_($i) subscribe"
}

# Define node initial position in nam
for {set i 0} {$i < $opt(nn)} {incr i} {
    $ns_ initial_node_pos $node_($i) 20
}

#
# Tell nodes when the simulation ends
#
for {set i 0} {$i < $opt(nn) } {incr i} {
    $ns_ at $opt(stop).1 "$node_($i) reset";
}

proc finish {} {
global ns_ tracefd nf
$ns_ flush-trace
close $tracefd
close $nf
exec nam DD.nam &
exit 0
}

# tell nam the simulation stop time
$ns_ at $opt(stop) "finish"
$ns_ at  $opt(stop)	"$ns_ nam-end-wireless $opt(stop)"
$ns_ at  $opt(stop).01 "puts \"NS EXITING...\" ; $ns_ halt"
puts "Starting Simulation..."
$ns_ run

