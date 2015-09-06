var IndexMessageThread = React.createClass({
  render: function() {
    return (
      <div className="list-group-item index-row" onClick={this.openThread}>
        <h5>
          <i className="fa fa-circle unread-message" />
          {this.props.message_thread.latest_message.subject}
        </h5>
        <h5>{this.props.message_thread.recipient.name}</h5>
        <p>{this.previewText()}</p>
      </div>
    );
  },
  previewText: function() {
    return this.props.message_thread.latest_message.body.substring(0, 100);
  },
  openThread: function(e) {
    this.props.index_list.props.messages_page.setState({ message_thread: this.props.message_thread });
  }
});

var IndexList = React.createClass({
  getInitialState: function() {
    return { message_threads: [] };
  },
  render: function() {
    return (
      <div>
        <LoadingIcon list={this.state.message_threads} />
        {this.state.message_threads.map(function(thread) {
          return <IndexMessageThread index_list={this} key={'message_thread_' + thread.id} message_thread={thread} />;
        }.bind(this))}
      </div>
    );
  },
  componentDidMount: function() {
    $.get('/api/v1/message_threads?include[]=recipient&include[]=latest_message', function(data) {
      if (this.isMounted()) {
        this.setState({ message_threads: data });
      }
    }.bind(this));
  }
});

var ExpandedMessageThread = React.createClass({
  getInitialState: function() {
    return { messages: [] };
  },
  componentDidMount: function() {
    $.get('/api/v1/message_threads/' + this.props.message_thread.id + '/messages?include[]=sender', function(data) {
      if (this.isMounted()) {
        this.setState({ messages: data });
      }
    }.bind(this));
  },
  render: function() {
    return (
      <div>
        <LoadingIcon list={this.state.messages} />
        {this.state.messages.map(function(message) {
          return (<div className="panel panel-default" key={'message_' + message.id}>
            <div className="panel-heading">
              <h4>{message.subject}</h4>
              <h5>
                {message.sender.name}
                <span className="pull-right">{message.created_at}</span>
              </h5>
            </div>
            <div className="panel-body">
              {message.body}
            </div>
          </div>);
        }.bind(this))}
      </div>
    );
  }
});

var MessagesPage = React.createClass({
  getInitialState: function() {
    return { message_thread: undefined };
  },
  render: function() {
    var threadToRender = undefined;
    if (this.state.message_thread)
      threadToRender = <ExpandedMessageThread messages_page={this} key={'expanded_thread_' + this.state.message_thread.id} message_thread={this.state.message_thread} />;
    else
      threadToRender = '';

    return (
      <div className="row">
        <div className="col-md-3">
          <div className="btn btn-primary">
            <i className="fa fa-plus" />
            New Message
          </div>
          <IndexList messages_page={this} />
        </div>
        <div className="col-md-9">
          {threadToRender}
        </div>
      </div>
    );
  }
});

$('body.messages.index').ready(function() {
  React.render(<MessagesPage />, $('#content')[0]);
});
