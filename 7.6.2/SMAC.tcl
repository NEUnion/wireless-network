set opt(chan)		Channel/WirelessChannel
set opt(prop)		Propagation/TwoRayGround
set opt(netif)      Phy/WirelessPhy
set opt(mac)        Mac/SMAC                                  ;# MAC type
set opt(ifq)		Queue/DropTail/PriQueue
set opt(ll)		LL
set opt(ant)        Antenna/OmniAntenna
set opt(x)		1000	                                  ;# X dimension of the topography
set opt(y)		800		                           ;# Y dimension of the topography
set opt(ifqlen)	50		                           ;# max packet in ifq
set opt(nn)          14		                           ;# number of nodes
set opt(seed)		1.0
set opt(stop)		100.0		                           ;# simulation time
set opt(tr)		SMAC.tr	                           ;# trace file
set opt(nam)		SMAC.nam	                           ;# animation file
set opt(rp)             DSR                                  ;# routing protocol script
set opt(energymodel)    EnergyModel
set opt(initialenergy)  15                                   ;# Initial energy in Joules

set ns_		[new Simulator]
set topo	[new Topography]
set tracefd	[open $opt(tr) w]
$ns_ use-newtrace
set namtrace    [open $opt(nam) w]
set prop	[new $opt(prop)]

$topo load_flatgrid $opt(x) $opt(y)
$ns_ trace-all $tracefd
$ns_ namtrace-all-wireless $namtrace $opt(x) $opt(y)
#
# Create god
#
create-god $opt(nn)

set chan_ [new $opt(chan)]

#global node setting
$ns_ node-config -adhocRouting $opt(rp) \
			-llType $opt(ll) \
			-macType $opt(mac) \
			-ifqType $opt(ifq) \
			-ifqLen $opt(ifqlen) \
			-antType $opt(ant) \
			-propType $opt(prop) \
			-phyType $opt(netif) \
			-channel $chan_ \
			-topoInstance $topo \
			-agentTrace ON \
			-routerTrace ON \
			-macTrace ON \
			-energyModel $opt(energymodel) \
			-idlePower 0.3442 \
			-rxPower 0.3682 \
			-txPower 0.386 \
          		-sleepPower 5.0e-5 \
          		-transitionPower 0.05 \
          		-transitionTime 0.0005 \
			-initialEnergy $opt(initialenergy)

for {set i 0} {$i < $opt(nn) } {incr i} {
	set node_($i) [$ns_ node]	
	$node_($i) random-motion 0		;# disable random motion
}

for {set i 0} {$i < 6} {incr i} {
       $node_($i) set X_ [expr $i*200]
       $node_($i) set Y_ [expr $opt(y)/2]
       $node_($i) set Z_ 0.0
}

$node_(6) set X_ 200
$node_(6) set Y_ 500
$node_(6) set Z_ 0.0

$node_(7) set X_ 200
$node_(7) set Y_ 300
$node_(7) set Z_ 0.0
    
$node_(8) set X_ 400
$node_(8) set Y_ 500
$node_(8) set Z_ 0.0
   
$node_(9) set X_ 400
$node_(9) set Y_ 300
$node_(9) set Z_ 0.0
        
$node_(10) set X_ 600
$node_(10) set Y_ 500
$node_(10) set Z_ 0.0

$node_(11) set X_ 600
$node_(11) set Y_ 300
$node_(11) set Z_ 0.0
 
$node_(12) set X_ 800
$node_(12) set Y_ 500
$node_(12) set Z_ 0.0

$node_(13) set X_ 800
$node_(13) set Y_ 300
$node_(13) set Z_ 0.0

for {set i 0} {$i < $opt(nn) } {incr i} {
    $ns_ initial_node_pos $node_($i) 40  ;# $ns_ initial_node_pos <node> <size> 
} 

set udp_(0) [new Agent/UDP]
$ns_ attach-agent $node_(0) $udp_(0)
set null_(0) [new Agent/Null]
$ns_ attach-agent $node_(5) $null_(0)
$ns_ connect $udp_(0) $null_(0)
set cbr_(0) [new Application/Traffic/CBR]
$cbr_(0) set packetSize_ 50
$cbr_(0) set interval_ 1.0
$cbr_(0) set random_ 0
$cbr_(0) set maxpkts_ 50
$cbr_(0) set fid_ 0
$cbr_(0) attach-agent $udp_(0)

$ns_ at 1.0 "$cbr_(0) start"

proc finish {} {
global ns_ tracefd namtrace
$ns_ flush-trace
close $tracefd
close $namtrace
exec nam SMAC.nam &
exit 0
}

#
# Tell all the nodes when the simulation ends

for {set i 0} {$i < $opt(nn) } {incr i} {
    $ns_ at $opt(stop) "$node_($i) reset";
}
$ns_ at $opt(stop).01 "finish"
$ns_ at $opt(stop).001 "puts \"NS EXITING...\" ; $ns_ halt"
puts "Starting Simulation..."
$ns_ run
