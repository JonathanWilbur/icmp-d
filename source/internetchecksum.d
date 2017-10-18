/** From RFC 792:
    The 16 bit one's complement of the one's complement sum of all 16
    bit words in the header.  For computing the checksum, the checksum
    field should be zero.  This checksum may be replaced in the
    future.

    ```C
        in 6
        {
            register long sum = 0;
            while( count > 1 ) {
                sum += * (unsigned short) addr++;
                count -= 2;
            }
            if( count > 0 )
                sum += * (unsigned char *) addr;
            while (sum>>16)
                sum = (sum & 0xffff) + (sum >> 16);
            checksum = ~sum;
        }
    ```
*/

/** Example implementation from http://www.netfor2.com/tcpsum.htm

```ObjectiveC
    typedef unsigned short u16;
    typedef unsigned long u32;

    u16 tcp_sum_calc(u16 len_tcp, u16 src_addr[],u16 dest_addr[], BOOL padding, u16 buff[])
    {
        u16 prot_tcp=6;
        u16 padd=0;
        u16 word16;
        u32 sum;	
        
        // Find out if the length of data is even or odd number. If odd,
        // add a padding byte = 0 at the end of packet
        if (padding&1==1){
            padd=1;
            buff[len_tcp]=0;
        }
        
        //initialize sum to zero
        sum=0;
        
        // make 16 bit words out of every two adjacent 8 bit words and 
        // calculate the sum of all 16 vit words
        for (i=0;i<len_tcp+padd;i=i+2){
            word16 =((buff[i]<<8)&0xFF00)+(buff[i+1]&0xFF);
            sum = sum + (unsigned long)word16;
        }	
        // add the TCP pseudo header which contains:
        // the IP source and destinationn addresses,
        for (i=0;i<4;i=i+2){
            word16 =((src_addr[i]<<8)&0xFF00)+(src_addr[i+1]&0xFF);
            sum=sum+word16;	
        }
        for (i=0;i<4;i=i+2){
            word16 =((dest_addr[i]<<8)&0xFF00)+(dest_addr[i+1]&0xFF);
            sum=sum+word16; 	
        }
        // the protocol number and the length of the TCP packet
        sum = sum + prot_tcp + len_tcp;

        // keep only the last 16 bits of the 32 bit calculated sum and add the carries
            while (sum>>16)
            sum = (sum & 0xFFFF)+(sum >> 16);
            
        // Take the one's complement of sum
        sum = ~sum;

    return ((unsigned short) sum);
    }
```

*/
module internetchecksum;

// REVIEW: nothrow?
public pure @safe
ushort internetChecksum(scope ubyte[] bytes ...)
{
    uint sum = 0; // REVIEW: Should this be larger?
    if (bytes.length % 2) bytes ~= [ 0x00 ];

    for (int i = 0; i < bytes.length; i += 2)
    {
        ushort word = (((bytes[i] << 8) & 0xFF00) + (bytes[i+1] & 0x00FF));
        sum += cast(uint) word;
    }

    while (sum >> 16)
        sum = ((sum & 0x0000FFFF) + (sum >> 16));

    return (cast(ushort) ~sum);
}

@safe
unittest
{
    // Source: https://en.wikipedia.org/wiki/IPv4_header_checksum
    assert(internetChecksum(0x45, 0x00, 0x00, 0x73, 0x00, 0x00, 0x40, 0x00, 0x40, 0x11, 0xc0, 0xa8, 0x00, 0x01, 0xc0, 0xa8, 0x00, 0xc7) == 0xB861);
    // Source: http://www.netfor2.com/checksum.html
    assert(internetChecksum(0x01, 0x00, 0xF2, 0x03, 0xF4, 0xF5, 0xF6, 0xF7) == 0x210E);
}