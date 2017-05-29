// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "web/static/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/my_app/endpoint.ex":
import {Socket} from "phoenix"
import {randomColor} from "randomcolor"
import _ from "lodash"

let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/2" function
// in "web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.

socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("dots", {})
const containerNode = document.querySelector('.container')

const DOT_DIAMETER_RANGE = {
  min: 10,
  max: 50,
}

function plotDots(dots, fadeIn = false) {
  _.forOwn(dots, (data, id) => {
    const dotNode = document.createElement('div')
    dotNode.className = 'circle'
    dotNode.id = id
    dotNode.style.backgroundColor = data.color
    const offset = data.diameter / 2
    dotNode.style.left = data.x - offset + 'px'
    dotNode.style.top = data.y - offset + 'px'
    dotNode.style.width = data.diameter + 'px'
    dotNode.style.height = data.diameter + 'px'
    containerNode.appendChild(dotNode)
    if (fadeIn) {
      dotNode.classList.add('fade-in')
    }
  })
}

function removeDot(dotNode) {
  if (dotNode.classList.contains('fade-in')) {
    dotNode.classList.remove('fade-in')
  }
  dotNode.classList.add('fade-out')
  setTimeout(() => containerNode.removeChild(dotNode), 1000)
}

function start(payload) {
  let dots = payload.dots

  // Plot dots on join
  plotDots(dots)

  document.body.addEventListener("click", event => {
    if (event.target === document.body) {
      // Add new dot
      const newDot = {
        color: randomColor(),
        x: event.pageX,
        y: event.pageY,
        diameter: _.random(DOT_DIAMETER_RANGE.min, DOT_DIAMETER_RANGE.max),
      }
      channel.push("dot:add", {new_dot_data: newDot})
    } else if (dots[event.target.id]) {
      // Delete existing dot
      channel.push("dot:delete", {dot_id: event.target.id})
    }
  })
  // Show new dot
  channel.on("dot:added", ({new_dot: new_dot}) => {
    Object.assign(dots, new_dot)
    plotDots(new_dot, true)
  })
  channel.on("dot:deleted", ({dot_id: dot_id}) => {
    delete dots[dot_id]
    const dotNode = document.getElementById(dot_id)
    removeDot(dotNode)
  })
}

channel.join()
  .receive("ok", start)
  .receive("error", resp => { console.log("Boo", resp) })

export default socket
