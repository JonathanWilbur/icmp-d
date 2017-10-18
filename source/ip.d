module ip;
import packet;

///
public alias DSCP = DifferentiatedServicesCodePoint;
/**
    I don't know how this works. The wiki is not particularly helpful.
*/
public
enum DifferentiatedServicesCodePoint : ubyte
{
    uhhhh = 0x00
}

///
public alias ECN = ExplicitCongestionNotification;
/**
    A possible value for the Explicit Congestion Notification (ECN)
    field of the IPv4 packet header.

    Standards:
        $(LINK2 https://tools.ietf.org/html/rfc3168, RFC3168)
*/
public
enum ExplicitCongestionNotification : ubyte
{
    nonExplicitCongestionNotificationCapableTransport = 0x00,
    explicitCongestionNotificationCapableTransport0 = 0x10,
    explicitCongestionNotificationCapableTransport1 = 0x01,
    congestionEncountered = 0x11
}

// TODO: Add RFCs in comments
// FIXME: Change names of enum values with ? comment.
/**
    A number assigned by the Internet Assigned Numbers Authority that is used
    within the Internet Protocol Version 4 (IPv4) header to identify what protocol
    is encapsulated within the Internet Protocol Version 4 (IPv4) packet.

    Standards:
        $(LINK2 http://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml,
             IANA Assigned Internet Protocol Numbers)
    See_Also:
        $(LINK2 https://en.wikipedia.org/wiki/List_of_IP_protocol_numbers,
            Wikipedia on IPv4 Protocol Numbers)
*/
public
enum AssignedInternetProtocolNumber : ubyte
{
    internetProtocolVersion6HopByHopOption = 0x00u,
    internetControlMessageProtocol = 0x01u,
    internetGroupManagementProtocol = 0x02u,
    gatewayToGatewayProtocol = 0x03u,
    internetProtocolInInternetProtocol = 0x04u,
    internetStreamProtocol = 0x05u,
    transmissionControlProtocol = 0x06u,
    coreBasedTrees = 0x07u,
    exteriorGatewayProtocol = 0x08u,
    interiorGatewayProtocol = 0x09u,
    bbnrccMonitoring = 0x0Au, // ?
    networkVoiceProtocol = 0x0Bu,
    xeroxPUP = 0x0Cu, // ?
    argus = 0x0Du, // ?
    emcon = 0x0Eu, // ?
    crossNetDebugger = 0x0Fu,
    chaos = 0x10u,
    userDatagramProtocol = 0x11u,
    multiplexing = 0x12u,
    dcnMeasurementSubsystems = 0x13u, // ?
    hostMonitoringProtocol = 0x14u,
    packetRadioMeasurement = 0x15u,
    xeroxNSIDP = 0x16u, // ?
    trunk1 = 0x17u,
    trunk2 = 0x18u,
    leaf1 = 0x19u,
    leaf2 = 0x1Au,
    reliableDataProtocol = 0x1Bu,
    internetReliableTransactionProtocol = 0x1Cu,
    isoTransportProtocolClass4 = 0x1Du,
    bulkDataTransferProtocol = 0x1Eu,
    mfeNetworkServicesProtocol = 0x1Fu, // ?
    meritInternodalProtocol = 0x20u, // ?
    datagramCongestionControlPRotocol = 0x21u,
    thirdPartyConnectProtocol = 0x22u,
    interDomainPolicyRoutingProtocol = 0x23u,
    xpressTransportProtocol = 0x24u,
    datagramDeliveryProtcol = 0x25u,
    idprControlMessageTransportProtocol = 0x26u,
    tpPlusPlusTransportProtocol = 0x27u, // ?
    ilTransportProtocol = 0x28u, // ?
    internetProtocolVersion6Encapsulation = 0x29u,
    sourceDemandRoutingProtocol = 0x2Au,
    routingHeaderForInternetProtocolVersion6 = 0x2Bu,
    fragmentHeaderForInternetProtocolVersion6 = 0x2Cu,
    interDomainRoutingProtocol = 0x2Du,
    resourceReservationProtocol = 0x2Eu,
    genericRoutingEncapsulation = 0x2Fu,
    dynamicSourceRoutingProtocol = 0x30u,
    burroughsNetworkArchitecture = 0x31u,
    encapsulatingSecurityPayload = 0x32u,
    authenticationHeader = 0x33u,
    integratedNetLayerSecurityProtocol = 0x34u,
    swipe = 0x35u, // ?
    nbmaAddressResolutionProtocol = 0x36u,
    internetProtocolMobility = 0x37u,
    transportLayerSecurityProtocol = 0x38u,
    simpleKeyManagementForInternetProtocol = 0x39u,
    internetControlMessageProtocolForInternetProtocolVersion6 = 0x3Au,
    noNextHeaderForInternetProtocolVersion6 = 0x3Bu,
    destinationOptionsForInternetProtocolVersion6 = 0x3Cu,
    anyHostInternalProtocol = 0x3Du, // ?
    cftp = 0x3Eu, // ?
    anyLocalNetwork = 0x3Fu,
    satnetAndBackroomEXPAK = 0x40u, // ?
    kryptolan = 0x41u,
    massachusettsInstituteOfTechnologyRemoteVirtualDiskProtocol = 0x42u,
    internetPluribusPacketCore = 0x43u,
    anyDistributedFileSystem = 0x44u, // ?
    satnetMonitoring = 0x45u, // ?
    visaProtocol = 0x46u, // ?
    internetPacketCoreUtility = 0x47u,
    computerProtocolNetworkExecutive = 0x48u,
    computerProtocolHeartBeat = 0x49u,
    wangSpanNetwork = 0x4Au,
    packetVideoProtocol = 0x4Bu,
    backroomSATNETMonitoring = 0x4Cu, // ?
    sunndprotocol = 0x4Du, // ?
    widebandMonitoring = 0x4Eu, // ?
    widebandExpak = 0x4Fu, // ?
    internationalOrganizationForStandardizationInternetProtocol = 0x50u,
    versatileMessageTransactionProtocol = 0x51u,
    secureVersatileMessageTransactionProtocol = 0x52u,
    vines = 0x53u, // ?
    ttp = 0x54u, // ? Duplicate with the one after it!
    internetProtocolTrafficManager = 0x54u, // Duplicate with the one before it!
    nsfnetIGP = 0x55u, // ?
    dissimilarGatewayProtocol = 0x56u,
    tcf = 0x57u, // ?
    enhancedInteriorGatewayRoutingProtocol = 0x58u,
    openShortestPathFirst = 0x59u,
    spriteRemoteProcedureCall = 0x5Au,
    locusAddressResolutionProtocol = 0x5Bu,
    multicastTransportProtocol = 0x5Cu,
    ax25 = 0x5Du,
    ka9qNOScompatibleIPoverIPTunneling = 0x5Eu,
    mobileInternetworkingControlProtocol = 0x5Fu,
    semaphoreCommunicationsSecPro = 0x60u,
    ethernetWithinInternetProtocolEncapsulation = 0x61u,
    encapsulationHeader = 0x62u,
    anyPrivateEncryptionScheme = 0x63u, // ?
    gmtp = 0x64u, // ?
    ipsilonFlowManagementProtocol = 0x65u,
    pnniOverInternetProtocol = 0x66u,
    protocolIndependentMulticast = 0x67u,
    aggregateRouteInternetProtocolSwitchingProtocol = 0x68u,
    spaceCommunicationsProtocolStandards = 0x69u,
    qnx = 0x6Au, // ?
    activeNetworks = 0x6Bu, // ?
    internetProtocolPayloadCompressionProtocol = 0x6Cu,
    sitaraNetworksProtocol = 0x6Du,
    compaqPeerProtocol = 0x6Eu,
    internetworkPacketExchangeInInternetProtocol = 0x6Fu,
    virtualRouterRedundancyProtocol = 0x70u, // Duplicate
    pgmReliableTransportProtocol = 0x71u, // ?
    any0hopProtocol = 0x72u, // ?
    layerTwoTunnelingProtocolVersion3 = 0x73u,
    dIIDataExchange = 0x74u,
    interactiveAgentTransferProtocol = 0x75u,
    scheduleTransferProtocol = 0x76u,
    spectraLinkRadioProtocol = 0x77u,
    universalTransportInterfaceProtocol = 0x78u,
    simpleMessageProtocol = 0x79u,
    simpleMulticastProtocol = 0x7Au,
    performanceTransparencyProtocol = 0x7Bu,
    intermediateSystemToIntermediateSystemProtocol = 0x7Cu,
    flexibleIntraASRoutingEnvironment = 0x7Du, // ?
    combatRadioTransportProtocol = 0x7Eu,
    combatRadioUserDatagram = 0x7Fu,
    serviceSpecificConnectionOrientedProtocolInAMultilinkAndConnectionlessEnvironment = 0x80u,
    iplt = 0x81u, // ?
    securePacketShield = 0x82u,
    privateInternetProtocolEncapsulationWithinInternetProtocol = 0x83u,
    streamControlTransmissionProtocol = 0x84u,
    fibreChannel = 0x85u,
    reservationProtocolEndToEndIgnore = 0x86u,
    mobilityExtensionHeaderForInternetProtocolVersion6 = 0x87u,
    lightweightUserDatagramProtocol = 0x88u,
    multiprotocolLabelSwitchingEncapsulatedInInternetProtocol = 0x89u,
    manet = 0x8Au, // ?
    hostIdentityProtocol = 0x8Bu,
    siteMultihomingByInternetProtocolVersion6Intermediation = 0x8Cu,
    wrappedEncapsulatingSecurityPayload = 0x8Du,
    robustHeaderCompression = 0x8Eu
    // 0x8F - 0xFC is Unassigned
    // 0xFD and 0xFE are for experimentation and testing
    // 0xFF is reserved for "extra"
}

///
alias IPv4Address = InternetProtocolVersion4Address;
///
public
struct InternetProtocolVersion4Address
{
    public immutable ubyte[4] bytes;

    public @safe nothrow
    this(ubyte[4] bytes ...)
    {
        this.bytes = bytes;
    }
}

///
alias IPv6Address = InternetProtocolVersion6Address;
///
public
struct InternetProtocolVersion6Address
{
    public immutable ubyte[16] bytes;

    public @safe nothrow
    this(ubyte[16] bytes ...)
    {
        this.bytes = bytes;
    }
}

///
alias IPPacket = InternetProtocolPacket;
///
abstract public 
class InternetProtocolPacket : BinaryPacket
{
    immutable ubyte ipVersion;
    public ubyte[] payload;
}

///
alias IPv4Packet = InternetProtocolVersion4Packet;
///
alias IPVersion4Packet = InternetProtocolVersion4Packet;
///
public
class InternetProtocolVersion4Packet : IPPacket
{
    public ubyte internetHeaderLength = 0x05u; // 5 rows of four bytes (20 bytes)
    public DSCP differentiatedServicesCodePoint = DSCP.uhhhh;
    public ECN explicitCongestionNotification = ECN.nonExplicitCongestionNotificationCapableTransport;
    public ushort length = 0x0014u; // IP Header + Payload
    public ushort identificationCode = 0x0000u;
    public bool dontFragment = false;
    public bool moreFragments = false;
    public ushort fragmentOffset = 0x0000u;
    public ubyte timeToLive = 0xFFu;
    public AssignedInternetProtocolNumber protocol = AssignedInternetProtocolNumber.transmissionControlProtocol;
    public ushort checksum;
    public IPv4Address source;
    public IPv4Address destination;
    private ubyte[] _contents;

    public @property
    ubyte[] header()
    {
        return [];
    }

    public @property
    ubyte[] contents()
    {
        return this._contents;
    }

    // FIXME: This needs to set the length field in the IP header!
    public @property
    void contents(ubyte[] content)
    {
        this._contents = content;
    }

    public @property
    ubyte[] footer()
    {
        return [];
    }

    public @safe nothrow
    this (AssignedInternetProtocolNumber protocol, IPv4Address source, IPv4Address destination, ubyte[] contents)
    {
        this.protocol = protocol;
        this.source = source;
        this.destination = destination;
        this._contents = contents;
    }
}