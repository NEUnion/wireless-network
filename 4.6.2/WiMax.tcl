set val(chan)   Channel/WirelessChannel    ;# channel type
set val(prop)   Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)  Phy/WirelessPhy            ;# network interface type
set val(mac)    Mac/802_16                 ;# MAC type
set val(ifq)    Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)     LL                         ;# link layer type
set val(ant)    Antenna/OmniAntenna        ;# antenna model
set val(ifqlen) 50                         ;# max packet in ifq
set val(nn)     11                         ;# number of mobilenodes
set val(rp)     DSDV                       ;# routing protocol
set val(x)      1000                       ;# X dimension of topography
set val(y)      1000                       ;# Y dimension of topography
set val(stop)   10.0                       ;# time of simulation end

#===================================
set ns            [new Simulator]
set tracefd       [open WiMax.tr w]
set namtrace      [open WiMax.nam w]

$ns trace-all $tracefd
$ns namtrace-all-wireless $namtrace $val(x) $val(y)

set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

create-god $val(nn)

set chan0 [new $val(chan)]
Mac/802_16 set channelSize_ 20
Mac/802_16 set modulation_ 0
Mac/802_16 set codeRate_ 0
#===================================

$ns node-config -adhocRouting $val(rp) \
                -llType $val(ll) \
                -macType $val(mac) \
                -ifqType $val(ifq) \
                -ifqLen $val(ifqlen) \
                -antType $val(ant) \
                -propType $val(prop) \
                -phyType $val(netif) \
                -channel $chan0 \
                -topoInstance $topo \
                -agentTrace OFF \
                -routerTrace OFF \
                -macTrace ON \
                -movementTrace OFF

#===================================

set node_(0) [$ns node]
$node_(0) set X_ 826
$node_(0) set Y_ 632
$node_(0) set Z_ 0.0
$ns initial_node_pos $node_(0) 20

set node_(1) [$ns node]
$node_(1) set X_ 818
$node_(1) set Y_ 406
$node_(1) set Z_ 0.0
$ns initial_node_pos $node_(1) 40

set node_(2) [$ns node]
$node_(2) set X_ 922
$node_(2) set Y_ 436
$node_(2) set Z_ 0.0
$ns initial_node_pos $node_(2) 40

set node_(3) [$ns node]
$node_(3) set X_ 1000
$node_(3) set Y_ 518
$node_(3) set Z_ 0.0
$ns initial_node_pos $node_(3) 40

set node_(4) [$ns node]
$node_(4) set X_ 1056
$node_(4) set Y_ 600
$node_(4) set Z_ 0.0
$ns initial_node_pos $node_(4) 40

set node_(5) [$ns node]
$node_(5) set X_ 1016
$node_(5) set Y_ 714
$node_(5) set Z_ 0.0
$ns initial_node_pos $node_(5) 40

set node_(6) [$ns node]
$node_(6) set X_ 978
$node_(6) set Y_ 798
$node_(6) set Z_ 0.0
$ns initial_node_pos $node_(6) 40

set node_(7) [$ns node]
$node_(7) set X_ 874
$node_(7) set Y_ 844
$node_(7) set Z_ 0.0
$ns initial_node_pos $node_(7) 40

set node_(8) [$ns node]
$node_(8) set X_ 760
$node_(8) set Y_ 842
$node_(8) set Z_ 0.0
$ns initial_node_pos $node_(8) 40

set node_(9) [$ns node]
$node_(9) set X_ 670
$node_(9) set Y_ 800
$node_(9) set Z_ 0.0
$ns initial_node_pos $node_(9) 40

set node_(10) [$ns node]
$node_(10) set X_ 624
$node_(10) set Y_ 724
$node_(10) set Z_ 0.0
$ns initial_node_pos $node_(10) 40

#===================================

#(CBR-UDP)
set udp0 [new Agent/UDP]
$ns attach-agent $node_(0) $udp0
set null0 [new Agent/Null]
$ns attach-agent $node_(1) $null0
$ns connect $udp0 $null0
$udp0 set fid_ 2
set cbr0 [new Application/Traffic/UGS]
$cbr0 attach-agent $udp0
$cbr0 set type_ CBR
$cbr0 set packet_size_ 1000封包大小
$cbr0 set rate_ 512Kb
$cbr0 set random_ false
$ns at 0.0 "$cbr0 start"
$ns at 10.0 "$cbr0 stop"

#(CBR-UDP)
set udp1 [new Agent/UDP]
$ns attach-agent $node_(0) $udp1
set null1 [new Agent/Null]
$ns attach-agent $node_(2) $null1
$ns connect $udp1 $null1
$udp1 set fid_ 2
set cbr1 [new Application/Traffic/UGS]
$cbr1 attach-agent $udp1
$cbr1 set type_ CBR
$cbr1 set packet_size_ 1000
$cbr1 set rate_ 512Kb
$cbr1 set random_ false
$ns at 0.0 "$cbr1 start"
$ns at 10.0 "$cbr1 stop"

#(CBR-UDP)
set udp2 [new Agent/UDP]
$ns attach-agent $node_(0) $udp2
set null2 [new Agent/Null]
$ns attach-agent $node_(3) $null2
$ns connect $udp2 $null2
$udp2 set fid_ 2
set cbr2 [new Application/Traffic/ertPS]
$cbr2 attach-agent $udp2
$cbr2 set type_ CBR
$cbr2 set packet_size_ 1000封包大小
$cbr2 set rate_ 512Kb
$cbr2 set random_ false
$ns at 0.0 "$cbr2 start"
$ns at 10.0 "$cbr2 stop"

#(CBR-UDP)
set udp3 [new Agent/UDP]
$ns attach-agent $node_(0) $udp3
set null3 [new Agent/Null]
$ns attach-agent $node_(4) $null3
$ns connect $udp3 $null3
$udp3 set fid_ 2
set cbr3 [new Application/Traffic/ertPS]
$cbr3 attach-agent $udp3
$cbr3 set type_ CBR
$cbr3 set packet_size_ 1000封包大小
$cbr3 set rate_ 512Kb
$cbr3 set random_ false
$ns at 0.0 "$cbr3 start"
$ns at 10.0 "$cbr3 stop"

#(CBR-UDP)
set udp4 [new Agent/UDP]
$ns attach-agent $node_(0) $udp4
set null4 [new Agent/Null]
$ns attach-agent $node_(5) $null4
$ns connect $udp4 $null4
$udp4 set fid_ 2
set cbr4 [new Application/Traffic/rtPS]
$cbr4 attach-agent $udp4
$cbr4 set type_ CBR
$cbr4 set packet_size_ 1000封包大小
$cbr4 set rate_ 512Kb
$cbr4 set random_ false
$ns at 0.0 "$cbr4 start"
$ns at 10.0 "$cbr4 stop"

#(CBR-UDP)
set udp5 [new Agent/UDP]
$ns attach-agent $node_(6) $udp5
set null5 [new Agent/Null]
$ns attach-agent $node_(0) $null5
$ns connect $udp5 $null5
$udp5 set fid_ 2
set cbr5 [new Application/Traffic/rtPS]
$cbr5 attach-agent $udp5
$cbr5 set type_ CBR
$cbr5 set packet_size_ 1000
$cbr5 set rate_ 512Kb
$cbr5 set random_ false
$ns at 0.0 "$cbr5 start"
$ns at 10.0 "$cbr5 stop"

#(CBR-UDP)
set udp6 [new Agent/UDP]
$ns attach-agent $node_(7) $udp6
set null6 [new Agent/Null]
$ns attach-agent $node_(0) $null6
$ns connect $udp6 $null6
$udp6 set fid_ 2
set cbr6 [new Application/Traffic/rtPS]
$cbr6 attach-agent $udp6
$cbr6 set type_ CBR
$cbr6 set packet_size_ 1000
$cbr6 set rate_ 512Kb
$cbr6 set random_ false
$ns at 0.0 "$cbr6 start"
$ns at 10.0 "$cbr6 stop"

#(CBR-UDP)
set udp7 [new Agent/UDP]
$ns attach-agent $node_(8) $udp7
set null7 [new Agent/Null]
$ns attach-agent $node_(0) $null7
$ns connect $udp7 $null7
$udp7 set fid_ 2
set cbr7 [new Application/Traffic/rtPS]
$cbr7 attach-agent $udp7
$cbr7 set type_ CBR
$cbr7 set packet_size_ 1000
$cbr7 set rate_ 512Kb
$cbr7 set random_ false
$ns at 0.0 "$cbr7 start"
$ns at 10.0 "$cbr7 stop"

#(CBR-UDP)
set udp8 [new Agent/UDP]
$ns attach-agent $node_(9) $udp8
set null8 [new Agent/Null]
$ns attach-agent $node_(0) $null8
$ns connect $udp8 $null8
$udp8 set fid_ 2
set cbr8 [new Application/Traffic/UGS]
$cbr8 attach-agent $udp8
$cbr8 set type_ CBR
$cbr8 set packet_size_ 1000
$cbr8 set rate_ 512Kb
$cbr8 set random_ false
$ns at 0.0 "$cbr8 start"
$ns at 10.0 "$cbr8 stop"

#(CBR-UDP)
set udp9 [new Agent/UDP]
$ns attach-agent $node_(10) $udp9
set null9 [new Agent/Null]
$ns attach-agent $node_(0) $null9
$ns connect $udp9 $null9
$udp9 set fid_ 2
set cbr9 [new Application/Traffic/UGS]
$cbr9 attach-agent $udp9
$cbr9 set type_ CBR
$cbr9 set packet_size_ 1000封包大小
$cbr9 set rate_ 512Kb
$cbr9 set random_ false
$ns at 0.0 "$cbr9 start"
$ns at 10.0 "$cbr9 stop"

for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "$node_($i) reset";
}

$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "stop"
$ns at 10.1 "puts \"end simulation\" ; $ns halt"

proc stop {} {
    global ns tracefd namtrace
    $ns flush-trace
    close $tracefd
    close $namtrace
    exec nam WiMax.nam &
    exit 0
}

$ns run
