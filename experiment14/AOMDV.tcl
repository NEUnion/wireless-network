# This script is created by NSG2 beta1
# <http://wushoupong.googlepages.com/nsg>

#===================================
#     Simulation parameters setup
#===================================
#Antenna/OmniAntenna set Gt_ 1              ;#Transmit antenna gain
#Antenna/OmniAntenna set Gr_ 1              ;#Receive antenna gain
#Phy/WirelessPhy set L_ 1.0                 ;#System Loss Factor
#Phy/WirelessPhy set freq_ 2.472e9          ;#channel
#Phy/WirelessPhy set bandwidth_ 11Mb        ;#Data Rate
#Phy/WirelessPhy set Pt_ 0.031622777        ;#Transmit Power
#Phy/WirelessPhy set CPThresh_ 10.0         ;#Collision Threshold
#Phy/WirelessPhy set CSThresh_ 5.011872e-12 ;#Carrier Sense Power
#Phy/WirelessPhy set RXThresh_ 5.82587e-08  ;#Receive Power Threshold
#Mac/802_11 set dataRate_ 11Mb              ;#Rate for Data Frames
#Mac/802_11 set basicRate_ 1Mb              ;#Rate for Control Frames

set val(chan)   Channel/WirelessChannel    ;# channel type
set val(prop)   Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)  Phy/WirelessPhy            ;# network interface type
set val(mac)    Mac/802_11                 ;# MAC type
set val(ifq)    Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)     LL                         ;# link layer type
set val(ant)    Antenna/OmniAntenna        ;# antenna model
set val(ifqlen) 50                         ;# max packet in ifq
set val(nn)     20                         ;# number of mobilenodes
set val(rp)     AOMDV                       ;# routing protocol
set val(x)      1567                      ;# X dimension of topography
set val(y)      100                      ;# Y dimension of topography
set val(stop)   100.0                         ;# time of simulation end

#===================================
#        Initialization        
#===================================
#Create a ns simulator
set ns [new Simulator]

#Setup topography object
set topo       [new Topography]
$topo load_flatgrid $val(x) $val(y)
set god_ [create-god $val(nn)]

#Open the NS trace file
set tracefile [open AOMDV.tr w]
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open AOMDV.nam w]
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
                -movementTrace ON

#===================================
#        Nodes Definition        
#===================================
#Create 20 nodes
set n0 [$ns node]
$ns initial_node_pos $n0 40
set n1 [$ns node]
$ns initial_node_pos $n1 40
set n2 [$ns node]
$ns initial_node_pos $n2 40
set n3 [$ns node]
$ns initial_node_pos $n3 40
set n4 [$ns node]
$ns initial_node_pos $n4 40
set n5 [$ns node]
$ns initial_node_pos $n5 40
set n6 [$ns node]
$ns initial_node_pos $n6 40
set n7 [$ns node]
$ns initial_node_pos $n7 40
set n8 [$ns node]
$ns initial_node_pos $n8 40
set n9 [$ns node]
$ns initial_node_pos $n9 40
set n10 [$ns node]
$ns initial_node_pos $n10 40
set n11 [$ns node]
$ns initial_node_pos $n11 40
set n12 [$ns node]
$ns initial_node_pos $n12 40
set n13 [$ns node]
$ns initial_node_pos $n13 40
set n14 [$ns node]
$ns initial_node_pos $n14 40
set n15 [$ns node]
$ns initial_node_pos $n15 40
set n16 [$ns node]
$ns initial_node_pos $n16 40
set n17 [$ns node]
$ns initial_node_pos $n17 40
set n18 [$ns node]
$ns initial_node_pos $n18 40
set n19 [$ns node]
$ns initial_node_pos $n19 40

source AOMDV-scn.tcl

#===================================
#        Agents Definition        
#===================================
#Setup a TCP connection
set tcp0 [new Agent/TCP]
$ns attach-agent $n8 $tcp0
set sink1 [new Agent/TCPSink]
$ns attach-agent $n0 $sink1
$ns connect $tcp0 $sink1
$tcp0 set packetSize_ 1500

#Setup a TCP/Reno connection
set tcp2 [new Agent/TCP/Reno]
$ns attach-agent $n7 $tcp2
set sink3 [new Agent/TCPSink]
$ns attach-agent $n9 $sink3
$ns connect $tcp2 $sink3
$tcp2 set packetSize_ 1500


#===================================
#        Applications Definition        
#===================================
#Setup a FTP Application over TCP connection
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ns at 1.0 "$ftp0 start"
$ns at 100.0 "$ftp0 stop"

#Setup a FTP Application over TCP/Reno connection
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp2
$ns at 1.0 "$ftp1 start"
$ns at 100.0 "$ftp1 stop"


#===================================
#        Termination        
#===================================
#Define a 'finish' procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam AOMDV.nam &
    exit 0
}
for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "\$n$i reset"
}
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run
