#===================================
#Simulation parameters setup
#===================================
set val(chan) Channel/WirelessChannel ;# channel type
set val(prop) Propagation/TwoRayGround ;# radio-propagation model
set val(netif) Phy/WirelessPhy ;# network interface type
set val(mac) Mac/802_11 ;# MAC type
set val(ifq) Queue/DropTail/PriQueue ;# interface queue type
set val(ll) LL  ;# link layer type
set val(ant) Antenna/OmniAntenna ;# antenna model
set val(ifqlen) 50 ;# max packet in ifq
set val(nn) 20 ;# number of mobilenodes
set val(rp) AODV ;# routing protocol
set val(x) 2283 ;# X dimension of topography
set val(y) 100 ;# Y dimension of topography
set val(stop) 10.0 ;# time of simulation end
#===================================
#Initialization
#===================================
#Create a ns simulator
set ns [new Simulator]
#Setup topography object
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)
#Open the NS trace file
set tracefile [open 3.9.tr w]
$ns trace-all $tracefile
#Open the NAM trace file
set namfile [open 3.9.nam w]
$ns namtrace-all $namfile
$ns namtrace-all-wireless $namfile $val(x) $val(y)
set chan [new $val(chan)];#Create wireless channel
#===================================
#Mobile node parameter setup
#===================================
$ns node-config -adhocRouting $val(rp) \
  -llType $val(ll) \
  -macType $val(mac) \
  -ifqType $val(ifq) \
  -ifqLen $val(ifqlen) \
  -antType $val(ant) \
  -propType $val(prop) \
  -phyType $val(netif) \
  -channel $chan \
  -topoInstance $topo \
  -agentTrace ON \
  -routerTrace ON \
  -macTrace ON \
  -movementTrace ON
#===================================
#Nodes Definition
#===================================
#Create 20 nodes
set n0 [$ns node]
$n0 set X_ 947
$n0 set Y_ 1191
$n0 set Z_ 0.0
$ns initial_node_pos $n0 20
set n1 [$ns node]
$n1 set X_ 1147
$n1 set Y_ 1191
$n1 set Z_ 0.0
$ns initial_node_pos $n1 20
set n2 [$ns node]
$n2 set X_ 1347
$n2 set Y_ 1191
$n2 set Z_ 0.0
$ns initial_node_pos $n2 20
set n3 [$ns node]
$n3 set X_ 1547
$n3 set Y_ 1191
$n3 set Z_ 0.0
$ns initial_node_pos $n3 20
set n4 [$ns node]
$n4 set X_ 1747
$n4 set Y_ 1191
$n4 set Z_ 0.0
$ns initial_node_pos $n4 20
set n5 [$ns node]

$n5 set X_ 947
$n5 set Y_ 991
$n5 set Z_ 0.0
$ns initial_node_pos $n5 20
set n6 [$ns node]
$n6 set X_ 1147
$n6 set Y_ 991
$n6 set Z_ 0.0
$ns initial_node_pos $n6 20
set n7 [$ns node]
$n7 set X_ 1347
$n7 set Y_ 991
$n7 set Z_ 0.0
$ns initial_node_pos $n7 20
set n8 [$ns node]
$n8 set X_ 1547
$n8 set Y_ 991
$n8 set Z_ 0.0
$ns initial_node_pos $n8 20
set n9 [$ns node]
$n9 set X_ 1747
$n9 set Y_ 991
$n9 set Z_ 0.0
$ns initial_node_pos $n9 20
set n10 [$ns node]
$n10 set X_ 947
$n10 set Y_ 791
$n10 set Z_ 0.0
$ns initial_node_pos $n10 20
set n11 [$ns node]
$n11 set X_ 1147
$n11 set Y_ 791
$n11 set Z_ 0.0
$ns initial_node_pos $n11 20
set n12 [$ns node]
$n12 set X_ 1347
$n12 set Y_ 791
$n12 set Z_ 0.0
$ns initial_node_pos $n12 20
set n13 [$ns node]
$n13 set X_ 1547
$n13 set Y_ 791
$n13 set Z_ 0.0
$ns initial_node_pos $n13 20

set n14 [$ns node]
$n14 set X_ 1747
$n14 set Y_ 791
$n14 set Z_ 0.0
$ns initial_node_pos $n14 20
set n15 [$ns node]
$n15 set X_ 947
$n15 set Y_ 591
$n15 set Z_ 0.0
$ns initial_node_pos $n15 20
set n16 [$ns node]
$n16 set X_ 1147
$n16 set Y_ 591
$n16 set Z_ 0.0
$ns initial_node_pos $n16 20
set n17 [$ns node]
$n17 set X_ 1347
$n17 set Y_ 591
$n17 set Z_ 0.0
$ns initial_node_pos $n17 20
set n18 [$ns node]
$n18 set X_ 1547
$n18 set Y_ 591
$n18 set Z_ 0.0
$ns initial_node_pos $n18 20
set n19 [$ns node]
$n19 set X_ 1747
$n19 set Y_ 591
$n19 set Z_ 0.0
$ns initial_node_pos $n19 20
#===================================
#Agents Definition
#===================================
#Setup a TCP connection
set tcp1 [new Agent/TCP]
$ns attach-agent $n0 $tcp1
set sink2 [new Agent/TCPSink]
$ns attach-agent $n19 $sink2
$ns connect $tcp1 $sink2
$tcp1 set packetSize_ 1500
#Setup a UDP connection
set udp3 [new Agent/UDP]

$ns attach-agent $n15 $udp3
set null4 [new Agent/Null]
$ns attach-agent $n4 $null4
$ns connect $udp3 $null4
$udp3 set packetSize_ 1500
#===================================
#Applications Definition
#===================================
#Setup a FTP Application over TCP connection
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp1
$ns at 1.0 "$ftp0 start"
$ns at 9.0 "$ftp0 stop"
#Setup a CBR Application over UDP connection
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp3
$cbr1 set packetSize_ 1000
$cbr1 set rate_ 1.0Mb
$cbr1 set random_ null
$ns at 1.0 "$cbr1 start"
$ns at 6.0 "$cbr1 stop"
#===================================
#Termination
#===================================
#Define a 'finish' procedure
proc finish {} {
global ns tracefile namfile
$ns flush-trace
close $tracefile
close $namfile
exec nam 3.9.nam &
exit 0
}
for {set i 0} {$i < $val(nn) } { incr i } {
$ns at $val(stop) "\$n$i reset"
}
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run
11
