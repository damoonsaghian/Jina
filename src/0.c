/*
https://www.cairographics.org/threaded_animation_with_cairo/
multi'threaded GUI (which GTK is not):
	container widget asks the children to stop drawing, and after receiving their reply, cleans their area,
	then sends the new areas to them to draw into
*/
