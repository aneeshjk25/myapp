class Api::TradesController < Api::BaseController
	def model_params
    	params.require(:trade).permit(:company_symbol, :trade_type, :reference,:trade_transaction_type, :amount,:unit, :time_of_trade  )
  	end
end