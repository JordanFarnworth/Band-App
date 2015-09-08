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

var MessageModal = React.createClass({
  getInitialState: function() {
    return { recipient_id: undefined, recipient_name: undefined, subject: undefined, body: undefined };
  },
  render: function() {
    return (
      <Modal onHide={this.close} key={'message_modal'}>
        <Modal.Header closeButton>
          New Message
        </Modal.Header>
        <Modal.Body className="message-form">
          <label>Recipient</label>
          <input type="text" id="message_recipient" className="form-control" value={this.state.recipient_name} onChange={this.updateState} />
          <label>Subject</label>
          <input type="text" id="message_subject" className="form-control" value={this.state.subject} onChange={this.updateState} />
          <label>Body</label>
          <textarea id="message_body" className="form-control" value={this.state.body} onChange={this.updateState} />
        </Modal.Body>
      </Modal>
    );
  },
  updateState: function(e) {
    if (e.target.id == 'message_recipient') this.setState({ recipient_name: e.target.value })
    if (e.target.id == 'message_subject') this.setState({ subject: e.target.value });
    if (e.target.id == 'message_body') this.setState({ body: e.target.value });
  },
  close: function() {
    this.props.messages_page.setState({ show_modal: false });
  },
  componentDidUpdate: function() {
    this.updateAutocomplete();
  },
  componentDidMount: function() {
    this.updateAutocomplete();
  },
  componentDidUnmount: function() {
    $('#message_recipient').autocomplete('destroy');
  },
  updateAutocomplete: function() {
    $('#message_recipient').autocomplete({
      source: function(request, response) {
        $.ajax('/api/v1/message_threads/recipients', {
          type: 'get',
          dataType: 'json',
          data: { q: request.term },
          success: function(data) {
            response($.map(data, function(obj) {
              return { value: obj.id, label: obj.name };
            }));
          }
        });
      },
      minLength: 3,
      appendTo: '.message-form',
      select: function(event, ui) {
        event.preventDefault();
        this.setState({ recipient_id: ui.item.value, recipient_name: ui.item.label });
      }.bind(this)
    });
  }
});

var MessagesPage = React.createClass({
  getInitialState: function() {
    return { message_thread: undefined, show_modal: false };
  },
  showModal: function() {
    this.setState({ show_modal: true });
  },
  render: function() {
    var threadToRender = undefined;
    if (this.state.message_thread)
      threadToRender = <ExpandedMessageThread messages_page={this} key={'expanded_thread_' + this.state.message_thread.id} message_thread={this.state.message_thread} />;
    else
      threadToRender = '';

    var modal = this.state.show_modal ? <MessageModal messages_page={this} /> : '';

    return (
      <div className="row">
        {modal}
        <div className="col-md-3">
          <div className="btn btn-primary" onClick={this.showModal}>
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
