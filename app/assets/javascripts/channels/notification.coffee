App.order = App.cable.subscriptions.create "NotificationChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    console.log('Channel conected')

  disconnected: ->
    # Called when the subscription has been terminated by the server
    console.log('Lost channel')

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    count = parseInt($('#orders_count').text())

    if isNaN(count)
      count = 1
    else
      count += 1;

    $('#orders_count').text(count)
    $('#orders_count').addClass("badge-danger")
    $('.fa-bell').addClass("bell-animation")

    text = I18n.t('notifications.text', user: data.notification.user_name, order: data.notification.order_internal_id, status: data.notification.order_status)
    link_order = I18n.t('notifications.link_order', order: data.notification.order_internal_id)
    notification = I18n.t('notifications.notification')
    time = $.timeago(data.notification.created_at)

    content = "<div class='notify container-fluid'" + " id='notify_" + data.notification.id + "'>" +
              "<div class='notify_order'>" +
              "<p>" + text + "</p>" +
              "</div>" +
              "<div class='notify_link'>" +
              "<a href='/orders/" + data.notification.order_slug + "' class='notification_order waves-effect waves-light'" + " id='notify-" + data.notification.id + "'>" + link_order + "</a>" +
              "<a href='/notifications/" + data.notification.slug + "' class='notification_link waves-effect waves-light'" + " id='notify-" + data.notification.id + "'>" + notification + "</a>" +
              "</div>" +
              "<div class='notify_time'>" + time + "</div>" +
              "</div>";

    $('#notifications_menu').after(content)

    # alert data.notification.order_slug
