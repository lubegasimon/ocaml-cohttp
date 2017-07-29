
module Server (Flow: Mirage_flow_lwt.S) = struct

  module Channel = Mirage_channel_lwt.Make(Flow)
  module HTTP_IO = Cohttp_mirage_io.Make(Channel)
  include Cohttp_lwt.Make_server(HTTP_IO)

  let listen spec flow =
    let ch = Channel.create flow in
    Lwt.finalize
      (fun () -> callback spec flow ch ch)
      (fun () -> Channel.close ch >|= fun _ -> ())

end
