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
    @name = new FullName(firstname, lastname)
    @sex = sex
    @birthday = birthday

  fullname: () ->
    @name.present()

  marry: (human) ->
    human.sex != @sex

  age: (date) ->
    @dateCulc.diffYear(@birthday, date)





describe "HumanSpec", () ->
  describe "fullname", () ->
    target = new Human('first', 'last')
    it "if firstname and lastname given then should return space separated string", () ->
      actual = target.fullname()
      assert(actual == 'first last')

  describe "sex", () ->
    it "should return true", () ->
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
    male = new Human('man1First', 'man1Last', true)
    male2 = new Human('man2First', 'man2Last', true)
    female = new Human('female1First', 'female1Last', false)

    it 'if given female and male then should return true', () ->
      assert male.marry(female)

    it 'if given same sex then should return false', () ->
      assert !male.marry(male2)


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
      assert target.age(today) == 24


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


