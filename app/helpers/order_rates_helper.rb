module OrderRatesHelper

  def month_names(month)
    months = ["",
              "Enero",
              "Febrero",
              "Marzo",
              "Abril",
              "Mayo",
              "Junio",
              "Julio",
              "Agosto",
              "Septiembre",
              "Octubre",
              "Nomvienbre",
              "Diciembre"]
    months[month]
  end

end
