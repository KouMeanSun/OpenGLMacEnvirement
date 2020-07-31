attribute vec4 position;
attribute vec2 texCoordinate;
varying lowp vec2 varyTextCoord;

void main(){
    varyTextCoord = texCoordinate;
    gl_Position = position;
}