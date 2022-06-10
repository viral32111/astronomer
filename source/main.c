#include <gtk/gtk.h>

static void button_clicked( GtkWidget *widget, gpointer data ) {
	g_print( "Hello World\n" );
}

static void window_destroy( GtkWidget *widget, gpointer data ) {
	g_print( "Window closed\n" );
}

static void application_activate( GtkApplication *application, gpointer user_data ) {
	GtkWidget *window = gtk_application_window_new( application );
	gtk_window_set_title( GTK_WINDOW( window ), "Example" );
	gtk_window_set_default_size( GTK_WINDOW( window ), 300, 200 );
	gtk_window_set_position( GTK_WINDOW( window ), GTK_WIN_POS_CENTER );
	g_signal_connect( window, "destroy", G_CALLBACK( window_destroy ), NULL );

	GtkWidget *button_box = gtk_button_box_new( GTK_ORIENTATION_HORIZONTAL );
	gtk_container_add( GTK_CONTAINER( window ), button_box );

	GtkWidget *button = gtk_button_new_with_label( "Print Message" );
	g_signal_connect( button, "clicked", G_CALLBACK( button_clicked ), NULL );
	//g_signal_connect_swapped( button, "clicked", G_CALLBACK( gtk_widget_destroy ), window );
	gtk_container_add( GTK_CONTAINER( button_box ), button );

	gtk_widget_show_all( window );
}

int main( int argument_count, char *argument_values[] ) {
	g_print( "GTK+ version: %d.%d.%d\n", gtk_major_version, gtk_minor_version, gtk_micro_version );
	g_print( "Glib version: %d.%d.%d\n", glib_major_version, glib_minor_version, glib_micro_version );

	GtkApplication *application = gtk_application_new( "com.viral32111.example", G_APPLICATION_FLAGS_NONE );
	g_signal_connect( application, "activate", G_CALLBACK( application_activate ), NULL );

	int status_code = g_application_run( G_APPLICATION( application ), argument_count, argument_values );
	g_object_unref( application );

	return status_code;
}
