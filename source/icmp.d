/**
    Internet Control Message Protocol, as formally described in the 
    $(LINK2 https://www.ietf.org, Internet Engineering Task Force)'s
    $(LINK2 https://tools.ietf.org/html/rfc792, RFC 792), and 
    Internet Control Message Protocol Version 6, as specified in the
    $(LINK2 https://www.ietf.org, Internet Engineering Task Force)'s
    $(LINK2 https://tools.ietf.org/html/rfc4443, RFC 4443).

    Authors: $(LINK2 http://jonathan.wilbur.space, Jonathan M. Wilbur), $(LINK2 mailto:jonathan@wilbur.space, jonathan@wilbur.space)
    License: $(LINK2 https://opensource.org/licenses/ISC, ISC License)
    Version: 0.1.0

    Standards:
        $(LINK2 https://tools.ietf.org/html/rfc792, RFC 792)
        $(LINK2 https://tools.ietf.org/html/rfc4443, RFC 4443)
    See_Also:
        $(LINK2 https://en.wikipedia.org/wiki/Internet_Control_Message_Protocol, 
            The Wikipedia Page for Internet Control Message Protocol)
*/
module icmp;
import internetchecksum;
import ip;
import std.datetime.systime : Clock, SysTime;

version (unittest)
{
    import std.stdio : writefln, writeln;
}

///
alias ICMPType = InternetControlMessageProtocolType;
///
enum InternetControlMessageProtocolType : ubyte
{
    echoReply = 0x00,
    destinationUnreachable = 0x03,
    redirect = 0x05,
    echoRequest = 0x08,
    routerAdvertisement = 0x09,
    routerSolicitation = 0x0A,
    timeExceeded = 0x0B,
    badInternetProtocolHeader = 0x0C,
    timestamp = 0x0D, // REVIEW: Should this be renamed to timestampRequest?
    timestampReply = 0x0E
}

///
alias ICMPDestinationUnreachableCode = InternetControlMessageProtocolDestinationUnreachableCode;
///
enum InternetControlMessageProtocolDestinationUnreachableCode : ubyte
{
    destinationNetworkUnreachable = 0x00,
    destinationHostUnreachable = 0x01,
    destinationProtocolUnreachable = 0x02,
    destinationPortUnreachable = 0x03,
    fragmentationRequired = 0x04,
    sourceRouteFailed = 0x05,
    destinationNetworkUnknown = 0x06,
    destinationHostUnknown = 0x07,
    sourceHostIsolated = 0x08,
    networkAdministrativelyProhibited = 0x09,
    hostAdministrativelyProhibited = 0x0A,
    networkUnreachableForTypeOfService = 0x0B,
    hostUnreachableForTypeOfService = 0x0C,
    communicationAdministrativelyProhibited = 0x0D,
    hostPrecedenceViolation = 0x0E,
    precedenceCutoffInEffect = 0x0F
}

///
alias ICMPRedirectCode = InternetControlMessageProtocolRedirectCode;
///
enum InternetControlMessageProtocolRedirectCode : ubyte
{
    redirectForTheNetwork = 0x00,
    redirectForTheHost = 0x01,
    redirectForTheTypeOfServiceAndNetwork = 0x02,
    redirectForTheTypeOfServiceAndHost = 0x03
}

///
alias ICMPEchoRequestCode = InternetControlMessageProtocolEchoRequestCode;
///
enum InternetControlMessageProtocolEchoRequestCode : ubyte
{
    request = 0x00
}

///
alias ICMPRouterAdvertisementCode = InternetControlMessageProtocolRouterAdvertisementCode;
///
enum InternetControlMessageProtocolRouterAdvertisementCode : ubyte
{
    advertise = 0x00
}

///
alias ICMPRouterSolicitationCode = InternetControlMessageProtocolRouterSolicitationCode;
///
enum InternetControlMessageProtocolRouterSolicitationCode : ubyte
{
    solicit = 0x00
}

///
alias ICMPTimeExceededCode = InternetControlMessageProtocolTimeExceededCode;
///
enum InternetControlMessageProtocolTimeExceededCode : ubyte
{
    timeToLiveExpiredInTransit = 0x00,
    fragmentReassemblyTimeExceeded = 0x01
}

///
alias ICMPBadIPHeaderCode = InternetControlMessageProtocolBadInternetProtocolHeaderCode;
///
alias ICMPBadInternetProtocolHeaderCode = InternetControlMessageProtocolBadInternetProtocolHeaderCode;
///
enum InternetControlMessageProtocolBadInternetProtocolHeaderCode : ubyte
{
    pointerIndicatesTheError = 0x00,
    missingARequiredOption = 0x01,
    badLength = 0x02
}

///
alias ICMPTimestampCode = InternetControlMessageProtocolTimestampCode;
///
enum InternetControlMessageProtocolTimestampCode : ubyte
{
    request = 0x00
}

///
alias ICMPTimestampReplyCode = InternetControlMessageProtocolTimestampReplyCode;
///
enum InternetControlMessageProtocolTimestampReplyCode : ubyte
{
    reply = 0x00
}

///
alias ICMPPacket = InternetControlMessageProtocolPacket;
/**
    The parent class from which other ICMP Packets will inherit.
    Because ICMP has multiple different variations of packets, each with 
    different fields, it is necessary that there be multiple classes
    that inherit from a base class. All ICMP packets have a type field,
    a code field (although the acceptable range of codes varies), 

    I believe that the end of the ICMP packet is intended to be determined by the
    length field of the IPv4 header. I have not confirmed this, though...
*/
abstract public
class InternetControlMessageProtocolPacket : BinaryPacket, CheckedPacket
{
    /**
        The type of the ICMP packet, which fundamentally shapes what fields
        are present or not present in the ICMP packet. Once the type is
        supplied, a code must be supplied to further specify the 

        While there are more types, they are obsoleted, and therefore, will
        not be supported by this library. This library supports the following
        types:

        $(UL
            $(LI echoReply = 0x00)
            $(LI destinationUnreachable = 0x03)
            $(LI redirectMessage = 0x05)
            $(LI echoRequest = 0x08)
            $(LI routerAdvertisement = 0x09)
            $(LI routerSolicitation = 0x0A)
            $(LI timeExceeded = 0x0B)
            $(LI badInternetProtocolHeader = 0x0C)
            $(LI timestamp = 0x0D)
            $(LI timestampReply = 0x0E)
        )
    */
    public ubyte type;

    /**
        A type-specific code that conveys further details about the packet.
    */
    public ubyte code;

    /**
        The bytes of the packet with the checksum field set to zero.
        This is what is used to calculate the checksum.
    */
    abstract public @property
    ubyte[] uncheckedBytes();

    /**
        The bytes of the packet with the checksum applied. The checksum 
        field is set to 0 when the checksum is calculated. uncheckedBytes() 
        is the "checkand" from which the checksum is calculated.
    */
    abstract public @property
    ubyte[] checkedBytes();
}

///
alias ICMPEchoReplyPacket = InternetControlMessageProtocolEchoReplyPacket;
/**
    Ping reply hexample, as captured by tcpdump:
    0000 ce4a 01ce 0001 fad8 d759 0000 0000 
    9ae0 0400 0000 0000 1011 1213 1415 1617 
    1819 1a1b 1c1d 1e1f 2021 2223 2425 2627 
    2829 2a2b 2c2d 2e2f 3031 3233 3435 3637 
*/
public
class InternetControlMessageProtocolEchoReplyPacket : ICMPPacket
{
    public ubyte            type = ICMPType.echoReply;
    public ubyte            code;
    public ushort           identifier;
    public ushort           sequence;
    public ubyte[]          payload;

    override public @property @trusted
    ubyte[] uncheckedBytes()
    {
        return (
            [ cast(ubyte) this.type, cast(ubyte) this.code, cast(ubyte) 0x00u, cast(ubyte) 0x00u ] ~
            *cast(ubyte[2] *) &(this.identifier) ~ 
            *cast(ubyte[2] *) &(this.sequence) ~
            this.payload
        );
    }

    override public @property @trusted
    ubyte[] checkedBytes()
    {
        ushort checksum = internetChecksum(this.uncheckedBytes);
        return (
            [ cast(ubyte) this.type, cast(ubyte) this.code ] ~
            *cast(ubyte[2] *) &checksum ~
            *cast(ubyte[2] *) &(this.identifier) ~ 
            *cast(ubyte[2] *) &(this.sequence) ~
            this.payload
        );
    }

    public @safe nothrow
    this (ubyte code = 0x00u, ushort identifier, ushort sequence, ubyte[] payload ...)
    {
        this.identifier = identifier;
        this.sequence = sequence;
        this.payload = payload;
    }
}

@safe
unittest
{
    ICMPEchoReply packet = new ICMPEchoReply(0x1234, 0x5678, 0x01, 0x02, 0x03, 0x04);
    writefln("%(%02X %)", packet.checkedBytes);
}

///
alias ICMPDestinationUnreachablePacket = InternetControlMessageProtocolDestinationUnreachablePacket;
///
public
class InternetControlMessageProtocolDestinationUnreachablePacket : ICMPPacket
{
    public ubyte            type = ICMPType.destinationUnreachable;
    public ubyte            code = ICMPDestinationUnreachableCode.destinationNetworkUnreachable;
    public ushort           unused = 0x0000u;
    public ushort           nextHopMaximumTransmissionUnit = 0x05DCu; // MTU set to 1500 is really common.
    public IPv4Packet       packet;

    override public @property @trusted
    ubyte[] uncheckedBytes()
    {
        return (
            [ this.type, this.code, 0x00u, 0x00u ] ~ 
            *cast(ubyte[2] *) &(this.unused) ~ 
            *cast(ubyte[2] *) &(this.nextHopMaximumTransmissionUnit) ~ 
            this.packet.header ~ 
            this.packet.contents[0 .. 8]
        );
    }

    override public @property @trusted
    ubyte[] checkedBytes()
    {
        ushort checksum = internetChecksum(this.uncheckedBytes);
        return (
            [ this.type, this.code ] ~ 
            *cast(ubyte[2] *) &checksum ~ 
            *cast(ubyte[2] *) &(this.unused) ~ 
            *cast(ubyte[2] *) &(this.nextHopMaximumTransmissionUnit) ~ 
            this.packet.header ~ 
            this.packet.contents[0 .. 8]
        );
    }

    public @safe nothrow
    this (ICMPDestinationUnreachableCode code, ushort nextHopMaximumTransmissionUnit, IPv4Packet packet)
    {
        this.code = code;
        this.nextHopMaximumTransmissionUnit = nextHopMaximumTransmissionUnit;
        this.packet = packet;
    }
}

@safe
unittest
{
    IPv4Address source = IPv4Address(0x7F, 0x00, 0x00, 0x01);
    IPv4Address destination = IPv4Address(0x7F, 0x00, 0x00, 0x01);
    IPv4Packet ip = new IPv4Packet(
        AssignedInternetProtocolNumber.internetControlMessageProtocol,
        source, destination, 
        [ 'H', 'E', 'N', 'L', 'O', ' ', 'B', 'O', 'R', 'T', 'H', 'E', 'R', 'S' ]);
    ICMPDestinationUnreachable packet = 
        new ICMPDestinationUnreachable(
            ICMPDestinationUnreachableCode.destinationHostUnknown, 
            0x05DCu, ip);

    writefln("%(%02X %)", packet.checkedBytes);
}

///
alias ICMPRedirectPacket = InternetControlMessageProtocolRedirectPacket;
///
public
class InternetControlMessageProtocolRedirectMessagePacket : ICMPPacket
{
    public immutable ubyte   type = ICMPType.redirect;
    public ubyte                code = ICMPRedirectCode.redirectForTheNetwork;
public IPv4Address                      gateway;
    public IPv4Packet                       payload;

    override public @property @trusted
    ubyte[] uncheckedBytes()
    {
        return (
            [ cast(ubyte) this.type, cast(ubyte) this.code, cast(ubyte) 0x00u, cast(ubyte) 0x00u ] ~
            this.gateway.bytes ~
            this.payload.header ~
            this.payload.contents[0 .. 8]
        );
    }

    override public @property @trusted
    ubyte[] checkedBytes()
    {
        ushort checksum = internetChecksum(this.uncheckedBytes);
        return (
            [ cast(ubyte) this.type, cast(ubyte) this.code ] ~
            *cast(ubyte[2] *) &checksum ~
            this.gateway.bytes ~
            this.payload.header ~
            this.payload.contents[0 .. 8]
        );
    }

    public @safe nothrow
    this (ICMPRedirectCode code, IPv4Address gateway, IPv4Packet payload)
    {
        this.code = code;
        this.gateway = gateway;
        this.payload = payload;
    }
}

unittest
{
    IPv4Address source = IPv4Address(0x7F, 0x00, 0x00, 0x01);
    IPv4Address destination = IPv4Address(0x7F, 0x00, 0x00, 0x01);
    IPv4Packet ip = new IPv4Packet(
        AssignedInternetProtocolNumber.internetControlMessageProtocol,
        source, destination, 
        [ 'H', 'E', 'N', 'L', 'O', ' ', 'B', 'O', 'R', 'T', 'H', 'E', 'R', 'S' ]);
    ICMPRedirectMessagePacket redirect = new ICMPRedirectMessagePacket(ICMPRedirectCode.redirectForTheHost, source, ip);
    writefln("Redirect: %(%02X %)", redirect.checkedBytes);
}

///
alias ICMPEchoRequest = InternetControlMessageProtocolEchoRequestPacket;
///
alias ICMPEchoRequestPacket = InternetControlMessageProtocolEchoRequestPacket;
/**
    Ping request hexample, as captured by tcpdump:
    0800 c64a 01ce 0001 fad8 d759 0000 0000 
    9ae0 0400 0000 0000 1011 1213 1415 1617 
    1819 1a1b 1c1d 1e1f 2021 2223 2425 2627 
    2829 2a2b 2c2d 2e2f 3031 3233 3435 3637
*/
public
class InternetControlMessageProtocolEchoRequestPacket : ICMPPacket
{
    public immutable ICMPType               type = ICMPType.echoRequest;
    public immutable ICMPEchoRequestCode    code = ICMPEchoRequestCode.request;
    public immutable ushort                 identifier;
    public immutable ushort                 sequence;
    public ubyte[]                          payload;

    override public @property @trusted
    ubyte[] uncheckedBytes()
    {
        return (
            [ cast(ubyte) this.type, cast(ubyte) this.code, cast(ubyte) 0x00u, cast(ubyte) 0x00u ] ~
            *cast(ubyte[2] *) &(this.identifier) ~ 
            *cast(ubyte[2] *) &(this.sequence) ~
            this.payload
        );
    }

    override public @property @trusted
    ubyte[] checkedBytes()
    {
        ushort checksum = internetChecksum(this.uncheckedBytes);
        return (
            [ cast(ubyte) this.type, cast(ubyte) this.code ] ~
            *cast(ubyte[2] *) &checksum ~
            *cast(ubyte[2] *) &(this.identifier) ~ 
            *cast(ubyte[2] *) &(this.sequence) ~
            this.payload
        );
    }

    public @safe nothrow
    this (ushort identifier, ushort sequence, ubyte[] payload ...)
    {
        this.identifier = identifier;
        this.sequence = sequence;
        this.payload = payload;
    }
}

@safe
unittest
{
    ICMPEchoRequest packet = new ICMPEchoRequest(0x1234, 0x5678, 0x01, 0x02, 0x03, 0x04);
    writefln("%(%02X %)", packet.checkedBytes);
}

// TODO: routerAdvertisement

/**
    https://tools.ietf.org/html/rfc1256

    6. Protocol Constants

    Router constants:
        MAX_INITIAL_ADVERT_INTERVAL       16 seconds
        MAX_INITIAL_ADVERTISEMENTS        3 transmissions
        MAX_RESPONSE_DELAY                2 seconds
    Host constants:
        MAX_SOLICITATION_DELAY            1 second
        SOLICITATION_INTERVAL             3 seconds
        MAX_SOLICITATIONS                 3 transmissions

    Additional protocol constants are defined with the message formats in
    Section 3, and with the router and host configuration variables in
    Sections 4.1 and 5.1.

    All protocol constants are subject to change in future revisions of
    the protocol.
*/
public
struct RouterPreference
{
    public IPv4Address routerAddress;
    public int preference;
}

///
alias ICMPRouterAdvertisement = InternetControlMessageProtocolRouterAdvertisementPacket;
///
alias ICMPRouterAdvertisementPacket = InternetControlMessageProtocolRouterAdvertisementPacket;
public
class InternetControlMessageProtocolRouterAdvertisementPacket : ICMPPacket
{
    public immutable ICMPType                       type = ICMPType.routerAdvertisement;
    public immutable ICMPRouterAdvertisementCode    code = ICMPRouterAdvertisementCode.advertise;
    public ubyte                                    numberOfAddresses = 0x00u;
    public immutable ubyte                          addressEntrySize = 0x02u;
    public ushort                                   lifetimeInSeconds = 0xFFFF;
    public RouterPreference[]                       routerPreferences = [];

    override public @property @trusted
    ubyte[] uncheckedBytes()
    {
        ubyte[] routerBytes;
        foreach (rp; this.routerPreferences)
        {
            routerBytes ~= (rp.routerAddress.bytes ~ *cast(ubyte[4] *) &(rp.preference));
        }
        return (
            [ cast(ubyte) this.type, cast(ubyte) this.code, cast(ubyte) 0x00u, cast(ubyte) 0x00u ] ~
            numberOfAddresses ~
            addressEntrySize ~
            *cast(ubyte[2] *) &(lifetimeInSeconds) ~
            routerBytes
        );
    }

    override public @property @trusted
    ubyte[] checkedBytes()
    {
        ushort checksum = internetChecksum(this.uncheckedBytes);
        ubyte[] routerBytes;
        foreach (rp; this.routerPreferences)
        {
            routerBytes ~= (rp.routerAddress.bytes ~ *cast(ubyte[4] *) &(rp.preference));
        }
        return (
            [ cast(ubyte) this.type, cast(ubyte) this.code ] ~
            *cast(ubyte[2] *) &checksum ~ 
            numberOfAddresses ~
            addressEntrySize ~
            *cast(ubyte[2] *) &(lifetimeInSeconds) ~
            routerBytes
        );
    }

    public @safe nothrow
    this (ushort lifetimeInSeconds, RouterPreference[] routers ...)
    {
        this.lifetimeInSeconds = lifetimeInSeconds;
        this.routerPreferences = routers;
    }
}

///
alias ICMPRouterSolicitation = InternetControlMessageProtocolRouterSolicitationPacket;
///
alias ICMPRouterSolicitationPacket = InternetControlMessageProtocolRouterSolicitationPacket;
public
class InternetControlMessageProtocolRouterSolicitationPacket : ICMPPacket
{
    public immutable ICMPType                       type = ICMPType.routerSolicitation;
    public immutable ICMPRouterSolicitationCode     code = ICMPRouterSolicitationCode.solicit;
    public ubyte[4]                                 reserved = [ 0x00u, 0x00u, 0x00u, 0x00u ];

    override public @property @trusted
    ubyte[] uncheckedBytes()
    {
        return (
            [ cast(ubyte) this.type, cast(ubyte) this.code, cast(ubyte) 0x00u, cast(ubyte) 0x00u ] ~
            this.reserved
        );
    }

    override public @property @trusted
    ubyte[] checkedBytes()
    {
        ushort checksum = internetChecksum(this.uncheckedBytes);
        return (
            [ cast(ubyte) this.type, cast(ubyte) this.code ] ~
            *cast(ubyte[2] *) &checksum ~ 
            this.reserved
        );
    }

    public @safe nothrow
    this (ushort lifetimeInSeconds, RouterPreference[] routers ...)
    {
        this.lifetimeInSeconds = lifetimeInSeconds;
        this.routerPreferences = routers;
    }
}

///
alias ICMPTimeExceeded = InternetControlMessageProtocolTimeExceededPacket;
///
alias ICMPTimeExceededPacket = InternetControlMessageProtocolTimeExceededPacket;
public
class InternetControlMessageProtocolRouterSolicitationPacket : ICMPPacket
{
    public immutable ICMPType       type = ICMPType.routerSolicitation;
    public ICMPTimeExceededCode     code = ICMPTimeExceededCode.timeToLiveExpiredInTransit;
    public ubyte[4]                 unused = [ 0x00u, 0x00u, 0x00u, 0x00u ];
    public IPv4Packet               payload;

    override public @property @trusted
    ubyte[] uncheckedBytes()
    {
        return (
            [ cast(ubyte) this.type, cast(ubyte) this.code, cast(ubyte) 0x00u, cast(ubyte) 0x00u ] ~
            this.unused ~
            this.payload.header ~
            this.payload.contents[0 .. 8]
        );
    }

    override public @property @trusted
    ubyte[] checkedBytes()
    {
        ushort checksum = internetChecksum(this.uncheckedBytes);
        return (
            [ cast(ubyte) this.type, cast(ubyte) this.code ] ~ 
            *cast(ubyte[2] *) &checksum ~ 
            this.unused ~ 
            this.payload.header ~ 
            this.payload.contents[0 .. 8]
        );
    }

    public @safe nothrow
    this (IPv4Packet payload)
    {
        this.payload = payload;
    }
}

///
alias ICMPParameterProblem = InternetControlMessageProtocolParameterProblemPacket;
///
alias ICMPParameterProblemPacket = InternetControlMessageProtocolParameterProblemPacket;
public
class InternetControlMessageProtocolRouterSolicitationPacket : ICMPPacket
{
    public immutable ICMPType       type = ICMPType.badInternetProtocolHeader;
    public ICMPTimeExceededCode     code = ICMPBadInternetProtocolHeaderCode.pointerIndicatesTheError;
    public ubyte                    pointer = 0x00u;
    public ubyte[3]                 unused = [ 0x00u, 0x00u, 0x00u ];
    public IPv4Packet               payload;

    override public @property @trusted
    ubyte[] uncheckedBytes()
    {
        return (
            [ cast(ubyte) this.type, cast(ubyte) this.code, cast(ubyte) 0x00u, cast(ubyte) 0x00u ] ~
            this.pointer ~
            this.unused ~
            this.payload.header ~
            this.payload.contents[0 .. 8]
        );
    }

    override public @property @trusted
    ubyte[] checkedBytes()
    {
        ushort checksum = internetChecksum(this.uncheckedBytes);
        return (
            [ cast(ubyte) this.type, cast(ubyte) this.code ] ~ 
            *cast(ubyte[2] *) &checksum ~ 
            this.pointer ~
            this.unused ~ 
            this.payload.header ~ 
            this.payload.contents[0 .. 8]
        );
    }

    public @safe nothrow
    this (IPv4Packet payload)
    {
        this.payload = payload;
    }
}

/* REVIEW:
    I don't quite understand how this works? How are you supposed to fill in all the
    timestamp fields beforehand?
*/
///
alias ICMPTimestamp = InternetControlMessageProtocolTimestampPacket;
///
alias ICMPTimestampPacket = InternetControlMessageProtocolTimestampPacket;
public
class InternetControlMessageProtocolTimestampPacket : ICMPPacket
{
    public immutable ICMPType       type = ICMPType.routerSolicitation;
    public ICMPTimestampCode        code = ICMPTimestampCode.timeToLiveExpiredInTransit;
    public SysTime                  originateTimestamp;
    public SysTime                  receiveTimestamp;
    public SysTime                  transmitTimestamp;

    override public @property @trusted
    ubyte[] uncheckedBytes()
    {
        return (
            [ cast(ubyte) this.type, cast(ubyte) this.code, cast(ubyte) 0x00u, cast(ubyte) 0x00u ] ~
            *cast(ubyte[4] *) &(originateTimestamp.toUnixTime!int) ~
            *cast(ubyte[4] *) &(receiveTimestamp.toUnixTime!int) ~
            *cast(ubyte[4] *) &(transmitTimestamp.toUnixTime!int)
        );
    }

    override public @property @trusted
    ubyte[] checkedBytes()
    {
        ushort checksum = internetChecksum(this.uncheckedBytes);
        return (
            [ cast(ubyte) this.type, cast(ubyte) this.code ] ~
            *cast(ubyte[2] *) &checksum ~ 
            *cast(ubyte[4] *) &(originateTimestamp.toUnixTime!int) ~
            *cast(ubyte[4] *) &(receiveTimestamp.toUnixTime!int) ~
            *cast(ubyte[4] *) &(transmitTimestamp.toUnixTime!int)
        );
    }

    public
    this (SysTime originateTimestamp, SysTime receiveTimestamp, SysTime transmitTimestamp)
    {
        this.originateTimestamp = originateTimestamp;
        this.receiveTimestamp = receiveTimestamp;
        this.transmitTimestamp = transmitTimestamp;
    }
}

///
alias ICMPTimestampReply = InternetControlMessageProtocolTimestampReplyPacket;
///
alias ICMPTimestampReplyPacket = InternetControlMessageProtocolTimestampReplyPacket;
public
class InternetControlMessageProtocolTimestampPacket : ICMPPacket
{
    public immutable ICMPType                   type = ICMPType.timestampReply;
    public immutable ICMPTimestampReplyCode     code = ICMPTimestampReplyCode.reply;
    public SysTime                              originateTimestamp;
    public SysTime                              receiveTimestamp;
    public SysTime                              transmitTimestamp;

    override public @property @trusted
    ubyte[] uncheckedBytes()
    {
        return (
            [ cast(ubyte) this.type, cast(ubyte) this.code, cast(ubyte) 0x00u, cast(ubyte) 0x00u ] ~
            *cast(ubyte[4] *) &(originateTimestamp.toUnixTime!int) ~
            *cast(ubyte[4] *) &(receiveTimestamp.toUnixTime!int) ~
            *cast(ubyte[4] *) &(transmitTimestamp.toUnixTime!int)
        );
    }

    override public @property @trusted
    ubyte[] checkedBytes()
    {
        ushort checksum = internetChecksum(this.uncheckedBytes);
        return (
            [ cast(ubyte) this.type, cast(ubyte) this.code ] ~
            *cast(ubyte[2] *) &checksum ~ 
            *cast(ubyte[4] *) &(originateTimestamp.toUnixTime!int) ~
            *cast(ubyte[4] *) &(receiveTimestamp.toUnixTime!int) ~
            *cast(ubyte[4] *) &(transmitTimestamp.toUnixTime!int)
        );
    }

    public
    this (SysTime originateTimestamp, SysTime receiveTimestamp, SysTime transmitTimestamp)
    {
        this.originateTimestamp = originateTimestamp;
        this.receiveTimestamp = receiveTimestamp;
        this.transmitTimestamp = transmitTimestamp;
    }
}