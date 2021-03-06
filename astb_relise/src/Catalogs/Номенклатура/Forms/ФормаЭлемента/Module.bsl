////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Свойства
 	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект,НОВЫЙ Структура("ИмяЭлементаДляРазмещения","ГруппаДополнительныеРеквизиты"));
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, ЭтаФорма.Элементы.ГруппаСертификаты.ПодчиненныеЭлементы.Сертификаты.КоманднаяПанель);
	// Конец СтандартныеПодсистемы.Печать
	
	//и.о. для СтандартныеПодсистемы.Печать
	Если Объект.Сертификаты.Количество()>0 Тогда
		Для каждого СтрТаблицы из Объект.Сертификаты Цикл
			СтрТаблицы.Ссылка = СтрТаблицы.Сертификат;
		КонецЦикла	
	КонецЕсли;	
	//Конец и.о. для СтандартныеПодсистемы.Печать
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	ЭтаФорма.Элементы.Комплектующие.Видимость = Объект.Комплект;
	ЭтаФорма.Элементы.УчитыватьКакКомплектВЗаказеПоставщикуИОтчетеДляСАП.Видимость = Объект.Комплект;
	//+++АСТБ_Горюшин_Алексей_17125
	ЭтаФорма.Элементы.ВидУчетаКомплектаДляППС.Видимость = Объект.Комплект;
	//---АСТБ_Горюшин_Алексей_17125
	//+++АСТБ_Горюшин_Алексей_49055
	ЭтаФорма.Элементы.ДекорацияСостоитВ_Комплекте.Видимость = СостоитВ_Комплекте();
	//---АСТБ_Горюшин_Алексей_49055
	
	//+++АСТБ_ALEXEY_110616_**************************************************************
	Элементы.ВидРоста.Видимость = Объект.ИспользоватьРост;
	//---АСТБ_ALEXEY_110616_**************************************************************
	
	УстановитьВидимостьЗвездочек(); 
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЗвездочек()
	
	Если Объект.Рейтинг < 0.2 Тогда
		Элементы.ДекорацияРейтинг0.Видимость 	= Истина;
		Элементы.ДекорацияРейтинг05.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг1.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг15.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг2.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг25.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг3.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг35.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг4.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг45.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг5.Видимость 	= Ложь;
	КонецЕсли;	
	
	Если Объект.Рейтинг > 0.2 И Объект.Рейтинг < 0.8 Тогда
		Элементы.ДекорацияРейтинг0.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг05.Видимость 	= Истина;
		Элементы.ДекорацияРейтинг1.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг15.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг2.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг25.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг3.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг35.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг4.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг45.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг5.Видимость 	= Ложь;
	КонецЕсли;
	
	Если Объект.Рейтинг > 0.7 И Объект.Рейтинг < 1.3 Тогда
		Элементы.ДекорацияРейтинг0.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг05.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг1.Видимость 	= Истина;
		Элементы.ДекорацияРейтинг15.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг2.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг25.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг3.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг35.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг4.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг45.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг5.Видимость 	= Ложь;
	КонецЕсли;
	
	Если Объект.Рейтинг > 1.2 И Объект.Рейтинг < 1.8 Тогда
		Элементы.ДекорацияРейтинг0.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг05.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг1.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг15.Видимость 	= Истина;
		Элементы.ДекорацияРейтинг2.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг25.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг3.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг35.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг4.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг45.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг5.Видимость 	= Ложь;
	КонецЕсли;
	
	Если Объект.Рейтинг > 1.7 И Объект.Рейтинг < 2.3 Тогда
		Элементы.ДекорацияРейтинг0.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг05.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг1.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг15.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг2.Видимость 	= Истина;
		Элементы.ДекорацияРейтинг25.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг3.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг35.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг4.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг45.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг5.Видимость 	= Ложь;
	КонецЕсли;
	
	Если Объект.Рейтинг > 2.2 И Объект.Рейтинг < 2.8 Тогда
		Элементы.ДекорацияРейтинг0.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг05.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг1.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг15.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг2.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг25.Видимость 	= Истина;
		Элементы.ДекорацияРейтинг3.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг35.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг4.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг45.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг5.Видимость 	= Ложь;
	КонецЕсли;
	
	Если Объект.Рейтинг > 2.7 И Объект.Рейтинг < 3.3 Тогда
		Элементы.ДекорацияРейтинг0.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг05.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг1.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг15.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг2.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг25.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг3.Видимость 	= Истина;
		Элементы.ДекорацияРейтинг35.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг4.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг45.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг5.Видимость 	= Ложь;
	КонецЕсли;
	
	Если Объект.Рейтинг > 3.2 И Объект.Рейтинг < 3.8 Тогда
		Элементы.ДекорацияРейтинг0.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг05.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг1.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг15.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг2.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг25.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг3.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг35.Видимость 	= Истина;
		Элементы.ДекорацияРейтинг4.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг45.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг5.Видимость 	= Ложь;
	КонецЕсли;
	
	Если Объект.Рейтинг > 3.7 И Объект.Рейтинг < 4.3 Тогда
		Элементы.ДекорацияРейтинг0.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг05.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг1.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг15.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг2.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг25.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг3.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг35.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг4.Видимость 	= Истина;
		Элементы.ДекорацияРейтинг45.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг5.Видимость 	= Ложь;
	КонецЕсли;
	
	Если Объект.Рейтинг > 4.2 И Объект.Рейтинг < 4.8 Тогда
		Элементы.ДекорацияРейтинг0.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг05.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг1.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг15.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг2.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг25.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг3.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг35.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг4.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг45.Видимость 	= Истина;
		Элементы.ДекорацияРейтинг5.Видимость 	= Ложь;
	КонецЕсли;
	
	Если Объект.Рейтинг > 4.7 Тогда
		Элементы.ДекорацияРейтинг0.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг05.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг1.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг15.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг2.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг25.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг3.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг35.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг4.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг45.Видимость 	= Ложь;
		Элементы.ДекорацияРейтинг5.Видимость 	= Истина;
	КонецЕсли;
	
КонецПроцедуры	

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
КонецПроцедуры

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
    ЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ "ПЕЧАТЬ"

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
  УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Сертификаты);
  
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	Если Не Объект.ФайлКартинки.Пустая() Тогда
		АдресКартинки = НавигационнаяСсылкаКартинки(Объект.ФайлКартинки, УникальныйИдентификатор)
	Иначе
		АдресКартинки = "";
	Конецесли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
 	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	//Танцюра А.Н. -- №110616 Доработка для доп. видов антропометрии -- 20.09.2021 <<<  
	Если ТекущийОбъект.ИспользоватьРост Тогда
		Если НЕ ЗначениеЗаполнено(ТекущийОбъект.ВидРоста) Тогда
			Отказ = Истина;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не заполнен вид роста!", , "Объект.ВидРоста");	
		КонецЕсли;
	КонецЕсли;	
	//Танцюра А.Н. -- №110616 Доработка для доп. видов антропометрии -- 20.09.2021 >>>
	
КонецПроцедуры

&НаКлиенте
Процедура КомплектПриИзменении(Элемент)
	
	ЭтаФорма.Элементы.Комплектующие.Видимость = Объект.Комплект;
	ЭтаФорма.Элементы.УчитыватьКакКомплектВЗаказеПоставщикуИОтчетеДляСАП.Видимость = Объект.Комплект;
	//+++АСТБ_Горюшин_Алексей_17125
	ЭтаФорма.Элементы.ВидУчетаКомплектаДляППС.Видимость = Объект.Комплект;
	//было
	//ЭтаФорма.Элементы.ВидУчетаКомплекта.Видимость = Объект.Комплект;
	//---АСТБ_Горюшин_Алексей_17125
	
КонецПроцедуры

&НаКлиенте
Процедура КомплектующиеПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ТекущиеДанные = Элементы.Комплектующие.ТекущиеДанные;
	Если ТекущиеДанные.Количество = 0 Тогда
		ТекущиеДанные.Количество = 1;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомплектующиеНоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Комплектующие.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		ТекущаяНоменклатура = ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка");
	Иначе
		ТекущаяНоменклатура = ТекущиеДанные.Номенклатура;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора",Новый Структура("СписокНоменклатуры", ПолучитьМассивНоменклатурыНаСервере(ТекущаяНоменклатура)),Элемент);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьМассивНоменклатурыНаСервере(ТекущаяНоменклатура)
	
	МассивНоменклатуры = Объект.Комплектующие.Выгрузить(,"Номенклатура").ВыгрузитьКолонку("Номенклатура");
	
	Если ЗначениеЗаполнено(ТекущаяНоменклатура) Тогда
		
		НайденныйИндекс = МассивНоменклатуры.Найти(ТекущаяНоменклатура);
		Если НЕ НайденныйИндекс = Неопределено Тогда
			
			МассивНоменклатуры.Удалить(НайденныйИндекс);
			
		КонецЕсли;
		
	КонецЕсли;
	
	МассивНоменклатуры.Добавить(Объект.Ссылка);
	
	Возврат МассивНоменклатуры;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НавигационнаяСсылкаКартинки(ФайлКартинки, ИдентификаторФормы)
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат ПрисоединенныеФайлы.ПолучитьДанныеФайла(ФайлКартинки, ИдентификаторФормы).СсылкаНаДвоичныеДанныеФайла;
	
КонецФункции

&НаКлиенте
Процедура ДобавитьИзображение(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ТекстВопроса = НСтр("ru='Для выбора изображения необходимо записать объект. Записать?'");
		
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопроса", ЭтаФорма, Параметры);
		
		ПоказатьВопрос(Оповещение,ТекстВопроса,РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;

    Записать();

	ВыборИзображения = Истина;
	ИдентификаторФайла = Новый УникальныйИдентификатор;
	
	ПрисоединенныеФайлыКлиент.ДобавитьФайлы(Объект.Ссылка, ИдентификаторФайла);
	ВыборИзображения = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьИзображение(Команда)
	
	Объект.ФайлКартинки = ПредопределенноеЗначение("Справочник.НоменклатураПрисоединенныеФайлы.ПустаяСсылка");
	АдресКартинки = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ПросмотретьИзображение(Команда)
	
	ПросмотретьПрисоединенныйФайл("ФайлКартинки", "АдресКартинки",
		НСтр("ru='Отсутствует изображение для просмотра'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьИзображение(Команда)
	
	ОчиститьСообщения();
	
	Если ЗначениеЗаполнено(Объект.ФайлКартинки) Тогда
		
		ПрисоединенныеФайлыКлиент.ОткрытьФормуПрисоединенногоФайла(Объект.ФайлКартинки);
		
	Иначе
		
		ТекстСообщения = НСтр("ru='Отсутствует изображение для редактирования'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "АдресКартинки");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПросмотретьПрисоединенныйФайл(ИмяРеквизитаОбъекта, ИмяРеквизитаФормы, ТекстСообщенияОбОшибке)
	
	ОчиститьСообщения();
	
	Если ЗначениеЗаполнено(Объект[ИмяРеквизитаОбъекта]) Тогда
		ПрисоединенныеФайлыКлиент.ОткрытьФайл(
			ПрисоединенныеФайлыСлужебныйВызовСервера.ПолучитьДанныеФайла(
				ЭтаФорма.Объект[ИмяРеквизитаОбъекта],
				УникальныйИдентификатор));
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщенияОбОшибке,, ИмяРеквизитаФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресКартинкиНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	// СтандартныеПодсистемы.ПрисоединенныеФайлы
	ПрисоединенныеФайлыКлиент.ОткрытьФормуВыбораФайлов(Объект.Ссылка, Элементы.ФайлКартинки);
	// Конец СтандартныеПодсистемы.ПрисоединенныеФайлы
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлКартинкиПриИзменении(Элемент)
	
	Если Не Объект.ФайлКартинки.Пустая() Тогда
		АдресКартинки = НавигационнаяСсылкаКартинки(Объект.ФайлКартинки, УникальныйИдентификатор)
	Иначе
		АдресКартинки = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлКартинкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	// СтандартныеПодсистемы.ПрисоединенныеФайлы
	ПрисоединенныеФайлыКлиент.ОткрытьФормуВыбораФайлов(Объект.Ссылка, Элементы.ФайлКартинки);
	// Конец СтандартныеПодсистемы.ПрисоединенныеФайлы
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ "СВОЙСТВА"

// СтандартныеПодсистемы.Свойства
 &НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма, Объект.Ссылка);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ...

// СтандартныеПодсистемы.Свойства
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	// Вставить содержимое обработчика.
	Элемент.ТекущиеДанные.Ссылка = Элемент.ТекущиеДанные.Сертификат;
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	
	ТекущиеДанные = Элементы.Сертификаты.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МассивФайлов = ПолучитьМассивФайловСертификатов(ТекущиеДанные.Сертификат);
	
	Для Каждого ЭлементМассива Из МассивФайлов Цикл
	
		ПараметрыФормы = Новый Структура("ИмяФайла", ЭлементМассива);
		ОткрытьФорму("Обработка.ПечатьСертификатов.Форма.Форма",ПараметрыФормы,ЭтаФорма,,,,,);
		
	КонецЦикла;	
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьМассивФайловСертификатов(ТекущийСертификат)
	
	МассивФайлов = Новый Массив;
	
	Для Каждого Сертификат Из ТекущийСертификат.ФайлыСертификата Цикл
		
		МассивФайлов.Добавить(Сертификат.ИмяФайла);
		
	КонецЦикла;	
	
	Возврат МассивФайлов;
	
КонецФункции	

// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура РедактироватьНавигационнуюСсылку(Команда)
	
	Подсказка = "Введите адрес в интернете";
	Оповещение = Новый ОписаниеОповещения("ПослеВводаСтроки",ЭтотОбъект);
	ПоказатьВводСтроки(Оповещение, , Подсказка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВводаСтроки(СсылкаНаТовар, ДополнительныеПараметры) Экспорт
	
    Если НЕ СсылкаНаТовар = Неопределено Тогда
        Объект.НавигационнаяСсылка = СсылкаНаТовар;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НавигационнаяСсылкаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ЗапуститьПриложение(Объект.НавигационнаяСсылка);
	
КонецПроцедуры

//+++АСТБ_Горюшин_Алексей_49055
&НаКлиенте
Процедура ДекорацияСостоитВ_КомплектеНажатие(Элемент)
	
	 ПараметрыФормы = Новый Структура("КлючВарианта, Отбор, СформироватьПриОткрытии, ВидимостьКомандВариантовОтчетов",
		"Основной",
		Новый Структура("Номенклатура", Объект.Ссылка),
		Истина,
		Ложь);    		
		
	ОткрытьФорму(
		"Отчет.НоменклатураСостоитВ_Комплекте.Форма",
		ПараметрыФормы,
		ЭтотОбъект,
		,
		Окно);
	
КонецПроцедуры //---АСТБ_Горюшин_Алексей_49055

//+++АСТБ_Горюшин_Алексей_49055
&НаСервере
Функция СостоитВ_Комплекте()
	
	Если Параметры.Ключ.Пустая() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НоменклатураКомплектующие.Ссылка КАК Комплект
		|ИЗ
		|	Справочник.Номенклатура.Комплектующие КАК НоменклатураКомплектующие
		|ГДЕ
		|	НоменклатураКомплектующие.Номенклатура = &Номенклатура";
	
	Запрос.УстановитьПараметр("Номенклатура", Объект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат Истина;
	КонецЕсли;		
	
	Возврат Ложь;
	
КонецФункции //---АСТБ_Горюшин_Алексей_49055

//+++АСТБ_ALEXEY_110616_**************************************************************

&НаКлиенте
Процедура ИспользоватьРостПриИзменении(Элемент)
	
	Элементы.ВидРоста.Видимость = Объект.ИспользоватьРост;
	
КонецПроцедуры

//---АСТБ_ALEXEY_110616_**************************************************************