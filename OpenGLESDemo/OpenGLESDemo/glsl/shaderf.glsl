varying lowp vec4 varyColor;
varying lowp vec2 varyTextCoord;
uniform sampler2D colorMap;
void main(){
    //gl_FragColor = varyColor;
    lowp vec4 tex = texture2D(colorMap,varyTextCoord);
    gl_FragColor = tex * varyColor;
}
