
## Genera plot de la cantidad de dispositivos en el hogar
plotly_hogares_cantidad_dispositivos <- function(.data, group_var_1, group_var_2, filter_var = group_var_2) {

   xaxis_title <- dplyr::case_when(
      group_var_1 == "localidad" ~ "Localidad",
      group_var_1 == "ingresos_total" ~ "Nivel de ingresos"
   )

   .data %>%
      dplyr::filter(
         !!rlang::sym(filter_var) == "Sí"
      ) %>%
      base::droplevels() %>%
      dplyr::mutate(
         group_var_1 = !!rlang::sym(group_var_1),
         group_var_2 = !!rlang::sym(
            stringr::str_replace(
               string = group_var_2,
               pattern = "tiene",
               replacement = "cantidad"
            )
         )
      ) %>%
      dplyr::group_by(
         group_var_1,
         group_var_2
      ) %>%
      dplyr::summarise(
         n = base::sum(peso_hogar, na.rm = TRUE),
         .groups = "drop_last"
      ) %>%
      dplyr::mutate(
         prop = n / base::sum(n, na.rm = TRUE)
      ) %>%
      dplyr::ungroup() %>%
      plotly::plot_ly() %>%
      plotly::add_trace(
         x = ~group_var_1,
         y = ~prop,
         color = ~group_var_2,
         colors = "Accent",
         type = "bar",
         hovertemplate = ~base::paste0(
            "%{y:0.2%}",
            "<extra></extra>"
         )
      ) %>%
      plotly::layout(
         xaxis = base::list(
            title = base::paste("<b>", xaxis_title, "</b>")
         ),
         yaxis = base::list(
            title = "<b>Porcentaje de los hogares</b>",
            tickformat = "%"
         )
      ) %>%
      plotlyLayout() %>%
      plotlyLegend() %>%
      plotlyConfig()
}