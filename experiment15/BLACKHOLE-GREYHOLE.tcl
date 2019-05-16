# This script is created by NSG2 beta1
# <http://wushoupong.googlepages.com/nsg>

#===================================
#     Simulation parameters setup
#===================================
set val(chan)   Channel/WirelessChannel    ;# channel type
set val(prop)   Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)  Phy/WirelessPhy            ;# network interface type
set val(mac)    Mac/802_11                 ;# MAC type
set val(ifq)    Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)     LL                         ;# link layer type
set val(ant)    Antenna/OmniAntenna        ;# antenna model
set val(ifqlen) 100                         ;# max packet in ifq
set val(nn)     8                          ;# number of mobilenodes
set val(rp)     AODV                       ;# routing protocol
set val(x)      1101                      ;# X dimension of topography
set val(y)      601                      ;# Y dimension of topography
set val(stop)   10.0                         ;# time of simulation end

#===================================
#        Initialization        
#===================================
#Create a ns simulator
set ns [new Simulator]

#Setup topography object
set topo       [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)

#Open the NS trace file
set tracefile [open blackhole-greyhole.tr w]
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open blackhole-greyhole.nam w]
$ns namtrace-all $namfile
$ns namtrace-all-wireless $namfile $val(x) $val(y)
set chan [new $val(chan)];#Create wireless channel

#===================================
#     Mobile node parameter setup
#===================================
$ns node-config -adhocRouting  $val(rp) \
                -llType        $val(ll) \
                -macType       $val(mac) \
                -ifqType       $val(ifq) \
                -ifqLen        $val(ifqlen) \
                -antType       $val(ant) \
                -propType      $val(prop) \
                -phyType       $val(netif) \
                -channel       $chan \
                -topoInstance  $topo \
                -agentTrace    ON \
                -routerTrace   ON \
                -macTrace      OFF \
                -movementTrace OFF

#===================================
#        Nodes Definition        
#===================================
#Create 8 nodes
set n0 [$ns node]
$n0 set X_ 401
$n0 set Y_ 499
$n0 set Z_ 0.0
$ns initial_node_pos $n0 60
set n1 [$ns node]
$n1 set X_ 597
$n1 set Y_ 501
$n1 set Z_ 0.0
$ns initial_node_pos $n1 60
set n2 [$ns node]
$n2 set X_ 799
$n2 set Y_ 499
$n2 set Z_ 0.0
$ns initial_node_pos $n2 60
$ns at 6.0 "[$n2 set ragent_] blackhole"
set n3 [$ns node]
$n3 set X_ 999
$n3 set Y_ 499
$n3 set Z_ 0.0
$ns initial_node_pos $n3 60
set n4 [$ns node]
$n4 set X_ 398
$n4 set Y_ 202
$n4 set Z_ 0.0
$ns initial_node_pos $n4 60
set n5 [$ns node]
$n5 set X_ 599
$n5 set Y_ 201
$n5 set Z_ 0.0
$ns initial_node_pos $n5 60
set n6 [$ns node]
$n6 set X_ 802
$n6 set Y_ 200
$n6 set Z_ 0.0
$ns initial_node_pos $n6 60
$ns at 3.0 "[$n6 set ragent_] greyhole"
set n7 [$ns node]
$n7 set X_ 1001
$n7 set Y_ 202
$n7 set Z_ 0.0
$ns initial_node_pos $n7 60

#===================================
#        Agents Definition        
#===================================
#Setup a UDP connection
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
set null1 [new Agent/Null]
$ns attach-agent $n3 $null1
$ns connect $udp0 $null1
$udp0 set packetSize_ 1500

#Setup a UDP connection
set udp2 [new Agent/UDP]
$ns attach-agent $n4 $udp2
set null3 [new Agent/Null]
$ns attach-agent $n7 $null3
$ns connect $udp2 $null3
$udp2 set packetSize_ 1500


#===================================
#        Applications Definition        
#===================================
#Setup a CBR Application over UDP connection
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
$cbr0 set packetSize_ 1000
$cbr0 set rate_ 1.0Mb
$cbr0 set random_ null
$ns at 1.0 "$cbr0 start"
$ns at 10.0 "$cbr0 stop"

#Setup a CBR Application over UDP connection
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp2
$cbr1 set packetSize_ 1000
$cbr1 set rate_ 1.0Mb
$cbr1 set random_ null
$ns at 1.0 "$cbr1 start"
$ns at 10.0 "$cbr1 stop"


#===================================
#        Termination        
#===================================
#Define a 'finish' procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam blackhole-greyhole.nam &
    exit 0
}
for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "\$n$i reset"
}
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run
