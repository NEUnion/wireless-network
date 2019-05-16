# ======================================================================
# Define options
# ======================================================================
set val(chan)           Channel/WirelessChannel    ;# Channel Type
set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy/802_15_4
set val(mac)            Mac/802_15_4
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn)             13                         ;# number of mobilenodes
set val(rp)             AODV                       ;# routing protocol
set val(x)		   30
set val(y)		   30
set val(traffic)	   ftp                        ;# cbr/poisson/ftp

set Stime1            0.02	;# in seconds 
set Stime2            0.25	;# in seconds 
set End               3	;# in seconds 

# Initialize Global Variables
set ns_		[new Simulator]
set tracefd     [open AODV.tr w]
$ns_ trace-all $tracefd
set namtrace     [open AODV.nam w]
$ns_ namtrace-all-wireless $namtrace $val(x) $val(y)
$ns_ puts-nam-traceall {# nam4wpan #}		

Mac/802_15_4 wpanNam namStatus on		;# default = off (should be turned on before other 'wpanNam' commands can work)



# For model 'TwoRayGround'
set dist(15m) 8.54570e-07

Phy/WirelessPhy set CSThresh_ $dist(15m)
Phy/WirelessPhy set RXThresh_ $dist(15m)

# set up topography object
set topo       [new Topography]
$topo load_flatgrid $val(x) $val(y)

# Create God
set god_ [create-god $val(nn)]

set chan_1_ [new $val(chan)]

# configure node

$ns_ node-config -adhocRouting $val(rp) \
		-llType $val(ll) \
		-macType $val(mac) \
		-ifqType $val(ifq) \
		-ifqLen $val(ifqlen) \
		-antType $val(ant) \
		-propType $val(prop) \
		-phyType $val(netif) \
		-topoInstance $topo \
		-agentTrace OFF \
		-routerTrace OFF \
		-macTrace ON \
		-movementTrace OFF \
		-channel $chan_1_ 

for {set i 0} {$i < $val(nn) } {incr i} {
	set node_($i) [$ns_ node]	
	$node_($i) random-motion 0		;# disable random motion
}

source ./AODV_topo.scn

proc ftppro { src dst starttime } {
   global ns_ node_
   set tcp($src) [new Agent/TCP]
   eval \$tcp($src) set packetSize_ 60
   set sink($dst) [new Agent/TCPSink]
   eval $ns_ attach-agent \$node_($src) \$tcp($src)
   eval $ns_ attach-agent \$node_($dst) \$sink($dst)
   eval $ns_ connect \$tcp($src) \$sink($dst)
   set ftp($src) [new Application/FTP]
   eval \$ftp($src) attach-agent \$tcp($src)
   $ns_ at $starttime "$ftp($src) start"
}

   set lowSpeed 0.20ms
   set highSpeed 1.4ms
   Mac/802_15_4 wpanNam PlaybackRate $lowSpeed
   
   
   ftppro 8 2 $Stime1
   ftppro 4 1 $Stime2

   Mac/802_15_4 wpanNam FlowClr -p AODV -c tomato
   Mac/802_15_4 wpanNam FlowClr -p tcp -s 8 -d 2 -c blue
   Mac/802_15_4 wpanNam FlowClr -p ack -s 2 -d 8 -c blue
   Mac/802_15_4 wpanNam FlowClr -p tcp -s 4 -d 1 -c green
   Mac/802_15_4 wpanNam FlowClr -p ack -s 1 -d 4 -c green


# defines the node size in nam
for {set i 0} {$i < $val(nn)} {incr i} {
	$ns_ initial_node_pos $node_($i) 2
}

# Tell nodes when the simulation ends
for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ at $End "$node_($i) reset";
}

$ns_ at $End "stop"

$ns_ at $End "$ns_ halt"

proc stop {} {
    global ns_ tracefd namtrace
    $ns_ flush-trace
    close $tracefd
    close $namtrace
    exec nam AODV.nam &
    exit 0
}

$ns_ run
