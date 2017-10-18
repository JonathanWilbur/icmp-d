module packet;

public
interface BinaryPacket
{
    public @property
    ubyte[] header();

    public @property
    ubyte[] contents();

    public @property
    void contents(ubyte[] content);

    public @property
    ubyte[] footer();

    // public @property
    // ubyte[] toBytes();

    // public
    // ubyte[] opCast(T = ubyte[])();
}

public
interface TextPacket
{
    public @property
    dstring header();

    public @property
    dstring contents();

    public @property
    dstring footer();
}

public
interface CheckedPacket
{
    /**
        Returns: the bytes that are used as the input to the checksum function.
    */
    public @property nothrow
    ubyte[] uncheckedBytes();

    public @property nothrow
    ubyte[] checkedBytes();

    public @property nothrow
    ubyte[] checksum();
}

public
interface DiagnosticPacket
{
    public bool ok;
}

public 
interface ApplicationLayerPacket
{

}

public
interface PresentationLayerPacket
{

}

public
interface SessionLayerPacket
{

}

public
interface TransportationLayerPacket
{

}

public
interface NetworkLayerPacket
{

}

public
interface DataLinkLayerPacket
{

}

public
interface PhysicalLayerPacket
{

}