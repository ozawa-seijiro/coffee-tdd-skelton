assert = require 'power-assert'

class FullName
  constructor: (firstname, lastname) ->
    @firstname = firstname
    @lastname = lastname

  present: () ->
    @fullname ?= @firstname + ' ' + @lastname
    return @fullname


class Date
  constructor: (date) ->
    result = date.split('-').map((n) -> parseInt(n))
    @year = result[0]
    @month = result[1]
    @day = result[2]


class DateCulc
  diffYear: (left, right) ->
    l = new Date(left)
    r = new Date(right)

    if l.month >= r.month
      if l.day <= r.day
        r.year - l.year
      else
        dy = r.year - l.year
        dy - 1
    else
      r.year - l.year


class Human
  constructor: (firstname, lastname, sex, birthday) ->
    @dateCulc = new DateCulc()
    @marryValid = new MarryValidator()
    @name = new FullName(firstname, lastname)
    @sex = sex
    @birthday = birthday

  fullname: () ->
    @name.present()

  marry: (human, today) ->
    @marryValid.valid(@, human, today)

  canMarry: (today) ->
    if @sex
      @age(today) > 17
    else
      @age(today) > 15

  age: (date) ->
    @dateCulc.diffYear(@birthday, date)


class MarryValidator
  valid: (left, right, today) =>
    left.canMarry(today) and right.canMarry(today) and left.sex != right.sex

describe "HumanSpec", () ->
  describe "fullname", () ->
    target = new Human('first', 'last')
    it "if firstname and lastname given then should return space separated string", () ->
      actual = target.fullname()
      assert(actual == 'first last')

  describe "canMarry", ->
    date = "2015-11-04"
    it 'if female, age is over 16 should return true', ->
      female = new Human('female', 'man1Last', false, '1092-01-01')
      assert.equal female.canMarry(date), true
    it 'if female, age is less than 16 should return false', ->
      female = new Human('female', 'man1Last', false, '2012-01-01')
      assert.equal female.canMarry(date), false
    it 'if male, age is less than 16 should return false', ->
      male = new Human('male', 'man1Last', true, '2012-01-01')
      assert.equal male.canMarry(date), false
    it 'if male, age is less than 16 should return true', ->
      male = new Human('male', 'man1Last', true, '1991-01-01')
      assert.equal male.canMarry(date), true

  describe "sex", ->
    it "should return true", ->
      target = new Human('first', 'last', true)
      sex = target.sex
      assert(sex == true)

    it "if given true in constructor then should return true", () ->
      target = new Human('first', 'last', true)
      sex = target.sex
      assert(sex == true)

    it "if given false in constructor then should return true", () ->
      target = new Human('first', 'last', false)
      sex = target.sex
      assert(sex == false)

  describe 'marry', () ->
    date = '2015-11-04'
    it 'if given female and male then should return true', ->
      male = new Human('man1First', 'man1Last', true, '1991-11-04')
      female = new Human('female1First', 'female1Last', false, '1991-11-04')
      assert.equal male.marry(female, date), true

    it 'if given same sex then should return false', ->
      male = new Human('man1First', 'man1Last', true, '1991-11-04')
      male2 = new Human('man2First', 'man2Last', true, '1991-11-04')
      assert.equal male.marry(male2, date), false

    context 'age validation', () ->
      maleNG = new Human('man1First', 'man1Last', true, '2012-01-01')
      maleOK = new Human('man2First', 'man2Last', true, '1992-01-01')
      femaleOK = new Human('female1First', 'female1Last', false, '1991-05-01')
      femaleNG = new Human('female1First', 'female1Last', false, '2014-05-01')

      it 'if males age is less than 18 should return false', () ->
        assert.equal maleNG.marry(femaleOK, date), false
      it 'if males age is greater than 18 should return true', () ->
        assert.equal maleOK.marry(femaleOK, date), true
      it 'if females age is less than 16 should return false', () ->
        assert.equal femaleNG.marry(maleOK, date), false
      it 'if females age is greater than 16 should return true', () ->
        assert.equal femaleOK.marry(maleOK, date), true


  describe 'birthday', () ->
    birthday = '1991-11-04'
    target = new Human('female1First', 'female1Last', false, birthday)
    it 'if given birthday then should return birthday', () ->
      assert target.birthday == '1991-11-04'


  describe 'age', () ->
    birthday = '1991-11-04'
    today = '2015-11-05'
    target = new Human('female1First', 'female1Last', false, birthday)
    it 'if given date then should return age', () ->
      assert.equal target.age(today), 24


describe "DateSpec", () ->
  it "should parse with constructor", () ->
    target = new Date('2014-05-24')
    assert.equal target.year, 2014
    assert.equal target.month, 5
    assert.equal target.day, 24



describe "dateCulcSpec", () ->
  target = new DateCulc()
  it "shuld return int", () ->
    left = '1991-11-04'
    right = '2015-11-05'
    diff = target.diffYear(left, right)
    assert.equal diff, 24

  it "shuld return int", () ->
    left = '1991-11-04'
    right = '2015-11-03'
    diff = target.diffYear(left, right)
    assert.equal diff, 23

  it "shuld return int", () ->
    left = '1991-11-04'
    right = '2015-11-04'
    diff = target.diffYear(left, right)
    assert.equal diff, 24

  it "shuld return int", () ->
    left = '1991-11-04'
    right = '2015-10-03'
    diff = target.diffYear(left, right)
    assert.equal diff, 23


