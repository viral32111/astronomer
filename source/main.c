#include <gtk/gtk.h>
#include <curl/curl.h>

static void button_clicked( GtkWidget *widget, gpointer data ) {
	CURL *curl = curl_easy_init();
	curl_easy_setopt( curl, CURLOPT_URL, "http://httpstat.us/200" );

	CURLcode result = curl_easy_perform( curl );
	if ( result != CURLE_OK ) {
		g_print( "cURL request failed: %s\n", curl_easy_strerror( result ) );
	}

	curl_easy_cleanup( curl );

	g_print( "\n" );
}

static void window_destroy( GtkWidget *widget, gpointer data ) {
	g_print( "Window closed\n" );
}

static void application_activate( GtkApplication *application, gpointer data ) {
	GtkWidget *window = gtk_application_window_new( application );
	gtk_window_set_title( GTK_WINDOW( window ), "Example" );
	gtk_window_set_default_size( GTK_WINDOW( window ), 300, 200 );
	//gtk_window_set_position( GTK_WINDOW( window ), GTK_WIN_POS_CENTER );
	g_signal_connect( window, "destroy", G_CALLBACK( window_destroy ), NULL );

	GtkWidget *button_box = gtk_box_new( GTK_ORIENTATION_HORIZONTAL, 0 );
	gtk_widget_set_halign( button_box, GTK_ALIGN_CENTER );
	gtk_widget_set_valign( button_box, GTK_ALIGN_CENTER );
	gtk_window_set_child( GTK_WINDOW( window ), button_box );

	GtkWidget *button = gtk_button_new_with_label( "Print Message" );
	g_signal_connect( button, "clicked", G_CALLBACK( button_clicked ), NULL );
	//g_signal_connect_swapped( button, "clicked", G_CALLBACK( gtk_window_destroy ), window );
	gtk_box_append( GTK_BOX( button_box ), button );

	gtk_widget_show( window );
}

int main( int argument_count, char *argument_values[] ) {
	curl_version_info_data *curl_version = curl_version_info( CURLVERSION_NOW );
	
	g_print( "GTK+ version: %d.%d.%d\n", GTK_MAJOR_VERSION, GTK_MINOR_VERSION, GTK_MICRO_VERSION );
	g_print( "Glib version: %d.%d.%d\n", glib_major_version, glib_minor_version, glib_micro_version );
	g_print( "cURL version: %s (%s)\n", curl_version->version, curl_version->ssl_version );

	GtkApplication *application = gtk_application_new( "com.viral32111.example", G_APPLICATION_FLAGS_NONE );
	g_signal_connect( application, "activate", G_CALLBACK( application_activate ), NULL );

	int status_code = g_application_run( G_APPLICATION( application ), argument_count, argument_values );
	g_object_unref( application );

	return status_code;
}
