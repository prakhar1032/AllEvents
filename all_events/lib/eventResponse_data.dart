class EventResponse {
  final Request request;
  final int count;
  final List<EventItem> items;

  EventResponse({
    required this.request,
    required this.count,
    required this.items,
  });

  factory EventResponse.fromJson(Map<String, dynamic> json) {
    return EventResponse(
      request: Request.fromJson(json['request']),
      count: json['count'],
      items: List<EventItem>.from(
          json['item'].map((item) => EventItem.fromJson(item))),
    );
  }
}

class Request {
  final String venue;
  final String ids;
  final String type;
  final String city;
  final int edate;
  final int page;
  final String keywords;
  final int sdate;
  final String category;
  final String cityDisplay;
  final int rows;

  Request({
    required this.venue,
    required this.ids,
    required this.type,
    required this.city,
    required this.edate,
    required this.page,
    required this.keywords,
    required this.sdate,
    required this.category,
    required this.cityDisplay,
    required this.rows,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      venue: json['venue'],
      ids: json['ids'],
      type: json['type'],
      city: json['city'],
      edate: json['edate'],
      page: json['page'],
      keywords: json['keywords'],
      sdate: json['sdate'],
      category: json['category'],
      cityDisplay: json['city_display'],
      rows: json['rows'],
    );
  }
}

class EventItem {
  final String eventId;
  final String eventName;
  final String eventNameRaw;
  final String ownerId;
  final String thumbUrl;
  final String thumbUrlLarge;
  final int startTime;
  final String startTimeDisplay;
  final int endTime;
  final String endTimeDisplay;
  final String location;
  final Venue venue;
  final String label;
  final int featured;
  final String eventUrl;
  final String shareUrl;
  final String bannerUrl;
  // final double score;
  final List<String> categories;
  // final List<String> tags;
  // final Tickets tickets;
  final List<dynamic> customParams;

  EventItem({
    required this.eventId,
    required this.eventName,
    required this.eventNameRaw,
    required this.ownerId,
    required this.thumbUrl,
    required this.thumbUrlLarge,
    required this.startTime,
    required this.startTimeDisplay,
    required this.endTime,
    required this.endTimeDisplay,
    required this.location,
    required this.venue,
    required this.label,
    required this.featured,
    required this.eventUrl,
    required this.shareUrl,
    required this.bannerUrl,
    // required this.score,
    required this.categories,
    // required this.tags,
    // required this.tickets,
    required this.customParams,
  });

  factory EventItem.fromJson(Map<String, dynamic> json) {
    return EventItem(
      eventId: json['event_id'],
      eventName: json['eventname'],
      eventNameRaw: json['eventname_raw'],
      ownerId: json['owner_id'],
      thumbUrl: json['thumb_url'],
      thumbUrlLarge: json['thumb_url_large'],
      startTime: json['start_time'],
      startTimeDisplay: json['start_time_display'],
      endTime: json['end_time'],
      endTimeDisplay: json['end_time_display'],
      location: json['location'],
      venue: Venue.fromJson(json['venue']),
      label: json['label'],
      featured: json['featured'],
      eventUrl: json['event_url'],
      shareUrl: json['share_url'],
      bannerUrl: json['banner_url'],
      // score: json['score'],
      categories: List<String>.from(json['categories']),
      // tags: List<String>.from(json['tags']),
      // tickets: Tickets.fromJson(json['tickets']),
      customParams: List<dynamic>.from(json['custom_params']),
    );
  }
}

class Venue {
  final String street;
  final String city;
  final String state;
  final String country;
  // final double latitude;
  // final double longitude;
  final String fullAddress;

  Venue({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    // required this.latitude,
    // required this.longitude,
    required this.fullAddress,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      // latitude: json['latitude'],
      // longitude: json['longitude'],
      fullAddress: json['full_address'],
    );
  }
}

// class Tickets {
//   final bool hasTickets;
//   final String ticketUrl;
//   final String ticketCurrency;
//   final int minTicketPrice;
//   final int maxTicketPrice;

//   Tickets({
//     required this.hasTickets,
//     required this.ticketUrl,
//     required this.ticketCurrency,
//     required this.minTicketPrice,
//     required this.maxTicketPrice,
//   });

//   factory Tickets.fromJson(Map<String, dynamic> json) {
//     return Tickets(
//       hasTickets: json['has_tickets'],
//       ticketUrl: json['ticket_url'],
//       ticketCurrency: json['ticket_currency'],
//       minTicketPrice: json['min_ticket_price'],
//       maxTicketPrice: json['max_ticket_price'],
//     );
//   }
// }
