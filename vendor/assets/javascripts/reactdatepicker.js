var DateUtilities = {
    pad: function(value, length) {
        while (value.length < length)
            value = "0" + value;
        return value;
    },

    clone: function(date) {
        return new Date(date.getFullYear(), date.getMonth(), date.getDate(), date.getHours(), date.getMinutes(), date.getSeconds(), date.getMilliseconds());
    },

    toString: function(date) {
      if (date) {
        return DateUtilities.pad((date.getMonth()+1).toString(), 2) + "/" + DateUtilities.pad(date.getDate().toString(), 2) + "/" + date.getFullYear();
      }
    },

    toDayOfMonthString: function(date) {
        return DateUtilities.pad(date.getDate().toString());
    },

    toMonthAndYearString: function(date) {
        var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        return months[date.getMonth()] + " " + date.getFullYear();
    },

    toMonthString: function(date) {
        var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        return months[date.getMonth()];
    },

    moveToDayOfWeek: function(date, dayOfWeek) {
        while (date.getDay() !== dayOfWeek)
            date.setDate(date.getDate()-1);
        return date;
    },

    isSameDay: function(first, second) {
        return first.getFullYear() === second.getFullYear() && first.getMonth() === second.getMonth() && first.getDate() === second.getDate();
    },

    isBefore: function(first, second) {
        return first.getTime() < second.getTime();
    },

    isAfter: function(first, second) {
        return first.getTime() > second.getTime();
    },

    toDate: function(date){
      var vArray = date.split('/');
      var ret = undefined;

    if (vArray.length == 3)
    {
      var mm, dd, yyyy, noOfDays;
      mm = parseInt(vArray[0]);

      if (mm > 0 && mm <= 12)
      {
        dd = parseInt(vArray[1]);

        if (dd > 0 && dd <= 31)
        {
          yy = parseInt(vArray[2]);

          if (mm > 0 && dd > 0 && yy >= 0 && yy <= 9999)
          {
            yy = new Date('1,1,' + yy).getFullYear();
            mm = mm - 1

            if (yy % 4 == 0)
            {
              noOfDays=[31,29,31,30,31,30,31,31,30,31,30,31];
            }
            else
            {
              noOfDays=[31,28,31,30,31,30,31,31,30,31,30,31];
            }

            if (dd <= noOfDays[mm])
            {
              ret = new Date(yy,mm,dd);
            }
          }
        }
      }
    }
    return ret
    }


};

var DatePicker = React.createClass({displayName: "exports",
  getInitialState: function() {
    var def = this.props.selected || new Date();
    return {
      view: DateUtilities.clone(def),
      selected: this.props.showSelected ? DateUtilities.clone(def) : null,
      minDate: null,
      maxDate: null,
      id: this.getUniqueIdentifier(),
      manualInput: null,
      dateClass: this.props.addClass || "",
      calendarIcon: this.props.calendar
    };
  },

  componentDidMount: function() {
    document.addEventListener("click", this.hideOnDocumentClick);
  },

  componentWillUnmount: function() {
    document.removeEventListener("click", this.hideOnDocumentClick);
  },

  hideOnDocumentClick: function(e) {
    var klass = this.state.calendarIcon == 'false' ? this.state.dateClass+" date-picker-trigger-" : "calendar-icon date-picker-trigger-"
    if (e.target.className !==  klass + this.state.id && !this.parentsHaveClassName(e.target, "ardp-calendar-" + this.state.id) 
      && e.target.className != "react-datepicker__year-read-view--selected-year" && e.target.className != "" && e.target.className != "react-datepicker__year-read-view--down-arrow"
      && e.target.className != "react-datepicker__navigation react-datepicker__navigation--years react-datepicker__navigation--years-previous"
      && e.target.className != "react-datepicker__navigation react-datepicker__navigation--years react-datepicker__navigation--years-upcoming"
      && e.target.className != "react-datepicker__year-option" )
      this.hide();
  },

  getUniqueIdentifier: function() {
    function s4() {
      return Math.floor((1 + Math.random()) * 0x10000)
        .toString(16)
        .substring(1);
    }

    return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
  },

  parentsHaveClassName: function(element, className) {
    var parent = element;
    while (parent) {
      if (parent.className && parent.className.indexOf(className) > -1)
        return true;

      parent = parent.parentNode;
    }

        return false;
  },

  setMinDate: function(date) {
    this.setState({ minDate: date });
  },

  setMaxDate: function(date) {
    this.setState({ maxDate: date });
  },

  onSelect: function(day) {
    this.setState({ selected: day });
    this.hide();

    if (this.props.onSelect)
      this.props.onSelect(day);
  },

  show: function() {
    var trigger = this.refs.trigger,
    rect = trigger.getBoundingClientRect(),
    isTopHalf = rect.top > window.innerHeight/2,
    calendarHeight = 203;

    this.refs.calendar.show({
        top: isTopHalf ? (rect.top + window.scrollY - calendarHeight - 3) : (rect.top + trigger.clientHeight + window.scrollY + 3),
        left: rect.left
    });
  },

  hide: function() {
    this.refs.calendar.hide();
  },

  onManualInput: function(e){
    value = e.target.value;
    this.setState({manualInput: value});
    var date = DateUtilities.toDate(value);
    if (date)
      this.onSelect(date)
  },

  onManualInputBlur: function(e){
    this.setState({manualInput: null});
  },

  onChange: function(year){
    if(this.state.selected){
      this.state.view.setFullYear(year)
      this.state.selected.setFullYear(year)
      this.setState({selected: this.state.selected});
    }
    else{
      def = new Date()
      def.setFullYear(year)
      this.setState({view: def, selected: def})
    }
    if (this.props.onSelect)
      this.props.onSelect(this.state.selected);
  },

  clearInput: function(){
    this.props.onSelect(null);
    this.setState({manualInput: null, selected: undefined, view: new Date()});
  },

  render: function() {
    if (this.state.calendarIcon == 'false'){
      return React.createElement("div", {className: "ardp-date-picker"},
        React.createElement("div", {className: "clear-text-wrap-note"},
         React.createElement("input", {ref: "trigger", placeholder: this.props.placeholder, type: "text", className: this.state.dateClass + " date-picker-trigger-" + this.state.id, readOnly: true, value: (this.state.manualInput || DateUtilities.toString(this.state.selected)), onClick: this.show, onChange: this.onManualInput, onBlur: this.onManualInputBlur})),
         // React.createElement("img", {src:"/assets/calendar.svg", className: "calendar-icon date-picker-trigger-" + this.state.id, onClick: this.show}),
        React.createElement(Calendar, {ref: "calendar", id: this.state.id, view: this.state.view, selected: this.state.selected, onSelect: this.onSelect, minDate: this.state.minDate, maxDate: this.state.maxDate, onChange: this.onChange})
      );
    }
    else{
      return React.createElement("div", {className: "ardp-date-picker"},
        React.createElement("div", {className: "clear-text-wrap"},
          React.createElement("input", {ref: "trigger", type: "text", className: this.state.dateClass + " date-picker-trigger-" + this.state.id, readOnly: false, value: (this.state.manualInput || DateUtilities.toString(this.state.selected)), onClick: this.show, onChange: this.onManualInput, onBlur: this.onManualInputBlur}),
          React.createElement("a", {ref: 'clearInput', className: this.state.selected ? "react-datepicker__close-icon" : "react-datepicker__close-icon hide", onClick: this.clearInput})),
        React.createElement("img", {src:"/assets/calendar.svg", className: "calendar-icon date-picker-trigger-" + this.state.id, onClick: this.show}),
        React.createElement(Calendar, {ref: "calendar", id: this.state.id, view: this.state.view, selected: this.state.selected, onSelect: this.onSelect, minDate: this.state.minDate, maxDate: this.state.maxDate, onChange: this.onChange})
      );
    }
  }
});

var Calendar = React.createClass({displayName: "Calendar",
  getInitialState: function() {
    return {
      visible: false
    };
  },

  onMove: function(view, isForward) {
    this.refs.weeks.moveTo(view, isForward);
  },

  onTransitionEnd: function() {
    this.refs.monthHeader.enable();
  },

  show: function(position) {
    this.setState({visible: true})
  },

  hide: function() {
    if (this.state.visible)
      this.setState({ visible: false });
  },

  onChange: function(year){
    this.props.onChange(year)
  },

  render: function() {
    return React.createElement("div", {ref: "calendar", className: "ardp-calendar-" + this.props.id + " calendar" + (this.state.visible ? " calendar-show" : " calendar-hide"), style: this.state.style },
      React.createElement(MonthHeader, {ref: "monthHeader", view: this.props.view, onMove: this.onMove, onChange: this.onChange}),
      React.createElement(WeekHeader, null),
      React.createElement(Weeks, {ref: "weeks", view: this.props.view, selected: this.props.selected, onTransitionEnd: this.onTransitionEnd, onSelect: this.props.onSelect, minDate: this.props.minDate, maxDate: this.props.maxDate})
    );
  }
});

var MonthHeader = React.createClass({displayName: "MonthHeader",
  getInitialState: function() {
    return {
      view: DateUtilities.clone(this.props.view),
      enabled: true
    };
  },

  moveBackward: function() {
    var view = this.props.view || DateUtilities.clone(this.state.view);
    view.setMonth(view.getMonth()-1);
    this.move(view, false);
  },

  moveForward: function() {
    var view = this.props.view || DateUtilities.clone(this.state.view);
    view.setMonth(view.getMonth()+1);
    this.move(view, true);
  },

  move: function(view, isForward) {
    view = this.props.view || view;
    if (!this.state.enabled)
      return;

    this.setState({
      view: view,
      enabled: false
    });

    this.props.onMove(view, isForward);
  },

  enable: function() {
    this.setState({ enabled: true });
  },

  onChange: function(year){
    this.props.onChange(year);
  },

  render: function() {
    var enabled = this.state.enabled;
    return React.createElement("div", {className: "month-header"},
            React.createElement("i", {className: (enabled ? "" : " disabled"), onClick: this.moveBackward}, String.fromCharCode(9664)),
            React.createElement("span", null, DateUtilities.toMonthString(this.props.view || this.state.view)),
            React.createElement(YearDropdown, {ref: 'YearDropdown', year: this.props.selected || this.props.view, onChange: this.onChange}),
            React.createElement("i", {className: (enabled ? "" : " disabled"), onClick: this.moveForward}, String.fromCharCode(9654))
    );
  }
});

var WeekHeader = React.createClass({displayName: "WeekHeader",
  render: function() {
    return React.createElement("div", {className: "week-header"},
            React.createElement("span", null, "Sun"),
            React.createElement("span", null, "Mon"),
            React.createElement("span", null, "Tue"),
            React.createElement("span", null, "Wed"),
            React.createElement("span", null, "Thu"),
            React.createElement("span", null, "Fri"),
            React.createElement("span", null, "Sat")
    );
  }
});

var Weeks = React.createClass({displayName: "Weeks",
  getInitialState: function() {
    return {
      view: DateUtilities.clone(this.props.view),
      other: DateUtilities.clone(this.props.view),
      sliding: null
    };
  },

  componentDidMount: function() {
    this.refs.current.addEventListener("transitionend", this.onTransitionEnd);
  },

  onTransitionEnd: function() {
    this.setState({
      sliding: null,
      view: DateUtilities.clone(this.state.other)
    });

    this.props.onTransitionEnd();
  },

    getWeekStartDates: function(view) {
      view = this.props.view || view;
      view.setDate(1);
      view = DateUtilities.moveToDayOfWeek(DateUtilities.clone(view), 0);

      var current = DateUtilities.clone(view);
      current.setDate(current.getDate()+7);

      var starts = [view],
      month = current.getMonth();

      while (current.getMonth() === month) {
        starts.push(DateUtilities.clone(current));
              current.setDate(current.getDate()+7);
      }

      return starts;
    },

  moveTo: function(view, isForward) {
    view = this.props.view || view;
    this.setState({
      sliding: isForward ? "left" : "right",
      other: DateUtilities.clone(view)
    });
  },

  render: function() {
    return React.createElement("div", {className: "weeks"},
      React.createElement("div", {ref: "current", className: "current" + (this.state.sliding ? (" sliding " + this.state.sliding) : "")},
        this.renderWeeks(this.state.view)
      ),
      React.createElement("div", {ref: "other", className: "other" + (this.state.sliding ? (" sliding " + this.state.sliding) : "")},
        this.renderWeeks(this.state.other)
      )
    );
  },

  renderWeeks: function(view) {
    view = this.props.view || view;
    var starts = this.getWeekStartDates(view),
    month = starts[1].getMonth();

    return starts.map(function(s, i) {
      return React.createElement(Week, {key: i, start: s, month: month, selected: this.props.selected, onSelect: this.props.onSelect, minDate: this.props.minDate, maxDate: this.props.maxDate});
    }.bind(this));
  }
});

var Week = React.createClass({displayName: "Week",
  buildDays: function(start) {
    var days = [DateUtilities.clone(start)],
    clone = DateUtilities.clone(start);
    for (var i = 1; i <= 6; i++) {
      clone = DateUtilities.clone(clone);
      clone.setDate(clone.getDate()+1);
      days.push(clone);
    }
    return days;
  },

  isOtherMonth: function(day) {
    return this.props.month !== day.month();
  },

  getDayClassName: function(day) {
    var className = "day";
    if (DateUtilities.isSameDay(day, new Date()))
        className += " today";
    if (this.props.month !== day.getMonth())
        className += " other-month";
    if (this.props.selected && DateUtilities.isSameDay(day, this.props.selected))
        className += " selected";
    if (this.isDisabled(day))
      className += " disabled";
        return className;
    },

  onSelect: function(day) {
    if (!this.isDisabled(day))
      this.props.onSelect(day);
  },

  isDisabled: function(day) {
    var minDate = this.props.minDate,
    maxDate = this.props.maxDate;

    return (minDate && DateUtilities.isBefore(day, minDate)) || (maxDate && DateUtilities.isAfter(day, maxDate));
  },

  render: function() {
    var days = this.buildDays(this.props.start);
    return React.createElement("div", {className: "week"},
      days.map(function(day, i) {
          return React.createElement("div", {key: i, onClick: this.onSelect.bind(null, day), className: this.getDayClassName(day)}, DateUtilities.toDayOfMonthString(day))
      }.bind(this))
    );
  }
});

var YearDropdown = React.createClass({displayName: 'YearDropdown',

  getInitialState: function() {
    return {
      dropdownVisible: false
    }
  },

  componentWillMount: function(){
    this.setState({yearsList: this.generateYears(this.props.year.getFullYear())})
    document.addEventListener("click", this.hideOnDocumentClick);
  },

  componentWillUnmount: function() {
    document.removeEventListener("click", this.hideOnDocumentClick);
  },

  hideOnDocumentClick: function(e){
    if (e.target.className != "react-datepicker__year-read-view--selected-year" && e.target.className != "react-datepicker__year-read-view--down-arrow"
        && e.target.className != "react-datepicker__navigation react-datepicker__navigation--years react-datepicker__navigation--years-previous"
        && e.target.className != "react-datepicker__navigation react-datepicker__navigation--years react-datepicker__navigation--years-upcoming"
        && e.target.className != "react-datepicker__year-option")
      this.setState({dropdownVisible: false});
  },

  renderReadView: function() {
    return (
      <div className="react-datepicker__year-read-view" onClick={this.toggleDropdown}>
        <span className="react-datepicker__year-read-view--selected-year">{this.props.year.getFullYear()}</span>
        <span className="react-datepicker__year-read-view--down-arrow"></span>
      </div>
    )
  },

  renderDropdown: function() {
    return (
      <div className="react-datepicker__year-dropdown">
        {this.renderOptions()}
      </div>
    )
  },

  onChange: function(year) {
    this.toggleDropdown()
    if (year === this.props.year) return
    this.props.onChange(year)
  },

  toggleDropdown: function() {
    this.setState({
      dropdownVisible: !this.state.dropdownVisible
    })
  },

  renderOptions: function() {
    var selectedYear = this.props.year.getFullYear()

    var options = this.state.yearsList.map((function(year) {
      return (
        <div className="react-datepicker__year-option"
          key={year}
          onClick={this.onChange.bind(this, year)}>
          {selectedYear === year ? <span className="react-datepicker__year-option--selected">✓</span> : ''}
          {year}
        </div>
      )
     }).bind(this));

    options.unshift(
      <div className="react-datepicker__year-option"
          ref={"upcoming"}
          key={"upcoming"}
          onClick={this.incrementYears}>
        <a className="react-datepicker__navigation react-datepicker__navigation--years react-datepicker__navigation--years-upcoming"></a>
      </div>
    )
    options.push(
      <div className="react-datepicker__year-option"
          ref={"previous"}
          key={"previous"}
          onClick={this.decrementYears}>
        <a className="react-datepicker__navigation react-datepicker__navigation--years react-datepicker__navigation--years-previous"></a>
      </div>
    )
    return options
  },

  shiftYears: function(amount) {
    var years = this.state.yearsList.map(function (year) {
      return year + amount
    })

    this.setState({
      yearsList: years
    })
  },

  incrementYears: function() {
    return this.shiftYears(1)
  },

  decrementYears: function() {
    return this.shiftYears(-1)
  },

  generateYears: function(year) {
    var list = []
    for (var i = 0; i < 5; i++) {
      list.push(year - i)
    }
    return list
  },

  render: function() {
    return (
      <div className="calendar-year">
        {this.state.dropdownVisible ? this.renderDropdown() : this.renderReadView()}
      </div>
    )
  }
});
