#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	
	УстановитьПривилегированныйРежим(Истина);
	
	УстановитьПривилегированныйРежим(Истина);
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, Режим);
	Документы.ЗачетУпрощеннойВыдачи.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ЗапасыСерверПереопределяемый.ОтразитьВыданныеСредстваЗащиты(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСерверПереопределяемый.ОтразитьПотребностьВыдачиСИЗ(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСерверПереопределяемый.ОтразитьВыдачуПоПотребности(ДополнительныеСвойства, Движения, Отказ);
	СформироватьСписокРегистровДляКонтроля();
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура СформироватьСписокРегистровДляКонтроля()

	Массив = Новый Массив;
	
	//Контроль выполняется при проведении\отмене проведения не нового документа.
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Массив.Добавить(Движения.ВыданныеСредстваЗащиты);
		Массив.Добавить(Движения.ВыдачаПоПотребности);
		Массив.Добавить(Движения.ПотребностьВыдачиСИЗ);
	КонецЕсли;
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

#КонецЕсли