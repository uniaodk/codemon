shader_type canvas_item;
render_mode unshaded;

void fragment() {
COLOR = texture(TEXTURE, UV);//setup the default image
float lum = (COLOR.r+COLOR.g+COLOR.b)/3.0;//get the average
COLOR.xyz = vec3(lum);//set the average to get grayscale
}