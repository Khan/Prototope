/* 

And example to demonstrate how to use insets on Rects

*/


let r1 = new Rect({x:100, y:100, width:250, height:250})

console.log(r1.minX+","+r1.minY+":"+r1.maxX+","+r1.maxY);

//r1 = r1.inset({value: 10})
//r1 = r1.inset({horizontal: 20, vertical: 10})
r1 = r1.inset({top:10, right:20, bottom:30, left:40})

// This will trigger a protonope
//r1 = r1.inset({top:1000, right:20, bottom:30, left:40})


console.log(r1.minX+","+r1.minY+":"+r1.maxX+","+r1.maxY);



