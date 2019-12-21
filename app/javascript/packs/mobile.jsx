/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'mobile' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

const Hello = props => (
  <div>Hello {props.name}!</div>
)

Hello.defaultProps = {
  name: 'mobile readmaru'
}

Hello.propTypes = {
  name: PropTypes.string
}

function sleep (time) {
  return new Promise((resolve) => setTimeout(resolve, time));
}

document.addEventListener('DOMContentLoaded', () => {
  sleep(1500).then(() => {
    document.body.innerHTML = "";

    ReactDOM.render(
      <Hello />,
      document.body.appendChild(document.createElement('div')),
    )
  });

})
