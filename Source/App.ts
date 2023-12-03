
import { Image } from 'https://deno.land/x/imagescript@1.2.17/mod.ts'


const { debug , clear } = console

clear()

debug(`Starting debug server`)


const port = 8080;

const handler = async ( request : Request ) => {

    const url = new URL(request.url)

    const search = url.searchParams
    
    const website = search.get('Url')

    if( ! website )
        return new Response(JSON.stringify({
            error : `Missing Url Search Parameter`
        }),{ status : 400 })
    
    const response = await fetch(website,{
        
        headers : {
            'User-Agent' : `GitHub:Lewdware/FicsIt-E621 E621:Juizy Version:1.0.0`
        }
    })

    const type = response.headers.get('Content-Type')

    if( type?.startsWith('image/') )
        return new Response(await responseToImage(response),{ status : 200 })

    const data = ''

    return new Response(data,{ status : 200 })
}

console.log(`HTTP server running. Access it at: http://localhost:8080/`);
Deno.serve({ port }, handler);



async function responseToImage ( response : Response ){

    const buffer = await response.arrayBuffer()

    let image = await Image.decode(buffer)

    // const path = ``

    // const buffer = await Deno.readFile(path)

    // let image = await Image.decode(buffer)

    image = image.resize(200,Image.RESIZE_AUTO)

    const { height , width } = image

    console.log('Image Size',width,height)

    let data = ''

    for ( let y = height ; y >= 1 ; y -= 2 ){
        
        for ( let x = width ; x >= 1 ; x-- ){

            nextPixel(x,y)

            if( y > 1 )
                nextPixel(x,y - 1)
        }
    }

    function nextPixel ( x : number , y : number ){

        const [ r , g , b ] = image.getRGBAAt(x,y)

        data += 
            String(r).padStart(3,' ') +
            String(g).padStart(3,' ') +
            String(b).padStart(3,' ')
    }

    const body = 
        String(width).padStart(6,' ') + 
        String(height).padEnd(6,' ') + 
        data

    console.log('Body',body.length)

    return body
}