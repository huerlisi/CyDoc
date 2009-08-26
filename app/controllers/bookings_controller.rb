class BookingsController < ApplicationController
  # DELETE /booking/1
  def destroy
    @booking = Booking.find(params[:id])

    @booking.destroy
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.remove "booking_#{@booking.id}"
#          page.replace 'bookings_list_footer', :partial => 'bookings/list_footer'
        end
      }
    end
  end
end
