var LoadingIcon = React.createClass({
  render: function() {
    return this.props.list.length > 0 ? <span /> : <i className="fa fa-2x fa-spinner fa-pulse" />;
  }
})
