
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь; // отключаем стандартный вывод отчета - будем выводить программно 
	
	//УстановитьПривилегированныйРежим(Истина);
	
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();// Получаем настройки отчета
	
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных; // Создаем данные расшифровки 
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных; // Создаем компоновщик макета 

	//инициализируем настройки параметров отчета
	Параметр = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДатаАнализа"));
	Если не Параметр = Неопределено Тогда
		ДатаАнализа = КонецДня(Параметр.Значение.Дата);
		Параметр.Использование = Истина;
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
	Параметр = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Организация"));
	Если не Параметр = Неопределено Тогда
		Организация = Параметр.Значение;
		Параметр.Использование = Истина;
	Иначе
		Отказ = Истина;
	КонецЕсли;

	ИспользованиеФильтраПоПодразделению = Ложь;
	
	//Параметр = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Подразделение"));
	//Если не Параметр = Неопределено Тогда
	//	Подразделение = Параметр.Значение;
	//	ИспользованиеФильтраПоПодразделению = Параметр.Использование;
	//Иначе
	//	Отказ = Истина;
	//КонецЕсли;
	
	//компоновка тупа - вставляем фильтр за нее
	СхемаКомпоновкиДанных.НаборыДанных.ЗанятыеРабочиеМеста.Запрос = 
	"ВЫБРАТЬ разрешенные
	|   ЗанятыеРабочиеМестаОстатки.Организация,
	|	ЗанятыеРабочиеМестаОстатки.Подразделение,
	|	ЗанятыеРабочиеМестаОстатки.Должность,
	|	ЗанятыеРабочиеМестаОстатки.РабочееМесто,
	|	ЗанятыеРабочиеМестаОстатки.Сотрудник
	|ИЗ
	|	РегистрНакопления.ЗанятыеРабочиеМеста.Остатки(
	|			&ДатаАнализа,
	|			Организация = &Организация
	|				"+?(ИспользованиеФильтраПоПодразделению,"И Подразделение В ИЕРАРХИИ (&Подразделение)","")+") КАК ЗанятыеРабочиеМестаОстатки";
	
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	
	// Скомпонуем результат
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	
	//инициализируем таблицу подразделений
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ разрешенные
	               |	Подразделения.Ссылка,
	               |	Подразделения.Родитель,
	               |	0 КАК Уровень
	               |ИЗ
	               |	Справочник.Подразделения КАК Подразделения
	               |ГДЕ
	               |	"+?(ИспользованиеФильтраПоПодразделению ,"Подразделения.Ссылка В ИЕРАРХИИ(&СписокПодразделений) И ","")+"
	               |	 Подразделения.Владелец = &Организация
				   |	УПОРЯДОЧИТЬ ПО
				   |		Ссылка ИЕРАРХИЯ УБЫВ";
				   
	//Запрос.УстановитьПараметр("СписокПодразделений",Подразделение);
	Запрос.УстановитьПараметр("Организация",Организация);
	ТаблицаПодразделений = Запрос.Выполнить().Выгрузить();
	
	
	ТаблицаНормНулевогоУровня = ПолучитьТаблицуНормПодразделения(ДатаАнализа,Организация,Справочники.Подразделения.ПустаяСсылка());
	
	ТаблицаНормОрганизации = ПолучитьТаблицуНормПодразделения(ДатаАнализа,Организация);
	
	ТаблицаНорм = ТаблицаНормНулевогоУровня.Скопировать();
	ТаблицаНорм.Очистить();
	
	Если ТаблицаНормНулевогоУровня.Количество() = 0 Тогда
		НетНормНулевогоУровня = Истина;
	Иначе
		НетНормНулевогоУровня = Ложь;
	КонецЕсли;	
	СтруктураПоиска = Новый Структура;
	
	
	Для каждого СтрокаТаблицыПодразделений Из ТаблицаПодразделений Цикл
		
		ТекущееПодразделение = СтрокаТаблицыПодразделений.Ссылка;
		
		//рекурсионный цикл
		Пока 1=1 Цикл
		
		СтруктураПоиска.Вставить("Подразделение",ТекущееПодразделение);	
		
		//смотрим установлены ли нормы конкретного подразделения
		
		МассивНайденыхНорм = ТаблицаНормОрганизации.НайтиСтроки(СтруктураПоиска);
		
		Если не МассивНайденыхНорм.Количество() = 0 Тогда
			ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(МассивНайденыхНорм, ТаблицаНорм);
			//все заполнено - выход из цикла
			Прервать;
		Иначе
			//проверим, есть ли нормы у родителя
			СтруктураПоиска.Вставить("Подразделение",ТекущееПодразделение.Родитель);
			МассивНайденыхНорм = ТаблицаНорм.НайтиСтроки(СтруктураПоиска);
			Если не МассивНайденыхНорм.Количество() = 0 Тогда
				ДополнитьТаблицу(МассивНайденыхНорм, ТаблицаНорм, ТекущееПодразделение);
				//все заполнено - выход из цикла
				Прервать;
            КонецЕсли;
		КонецЕсли;	
		
		ТекущееПодразделение = ТекущееПодразделение.Родитель;
		
		Если ЗначениеЗаполнено(ТекущееПодразделение) Тогда
			СтруктураПоиска.Очистить();
			СтруктураПоиска.Вставить("СлужебнаяКолонка",ТекущееПодразделение);
			МассивНайденыхНорм = ТаблицаНорм.НайтиСтроки(СтруктураПоиска);
			СтруктураПоиска.Очистить();
            Если МассивНайденыхНорм.Количество() = 0 Тогда
				//родитель есть - прыгаем по иерархии вверх
				Продолжить;
			Иначе
				//у родителя норм нет, значит пробежка по иерархии ничего не даст
				НоваяСтрока = ТаблицаНорм.Добавить();
				НоваяСтрока.СлужебнаяКолонка = СтрокаТаблицыПодразделений.Ссылка;
				Прервать;
			КонецЕсли;	
		Иначе
			//Дотопали до корня. проверяем наличие НормНулевогоУровня
			Если НетНормНулевогоУровня Тогда
				//норм по подразделению нет - выход из цикла
				НоваяСтрока = ТаблицаНорм.Добавить();
				НоваяСтрока.СлужебнаяКолонка = СтрокаТаблицыПодразделений.Ссылка;
				Прервать;
			Иначе
				//пробрасываем нормы нулевого уровня
		        ДополнитьТаблицу(ТаблицаНормНулевогоУровня,ТаблицаНорм,СтрокаТаблицыПодразделений.Ссылка);
				Прервать;
			КонецЕсли;
		КонецЕсли;	
		
		КонецЦикла;
		
	КонецЦикла; 
	
	//СтруктураПоиска.Очистить();
	//СтруктураПоиска.Вставить("Подразделение",Неопределено);
	//МассивСтрок = ТаблицаНорм.НайтиСтроки(СтруктураПоиска);
	//Для каждого СтрокаМассива Из МассивСтрок Цикл
	//	
	//	СтрокаМассива.Организация = Организация;
	//	СтрокаМассива.Подразделение = СтрокаМассива.СлужебнаяКолонка;
	//
	//КонецЦикла; 
	
	//+++АСТБ_Горюшин_Алексей_54520
	ДобавлениеУточненныхОснованийНорм(ТаблицаНорм);
	//---АСТБ_Горюшин_Алексей_54520
	
	НаборыВнешнихДанных = Новый Структура;
	//НаборыВнешнихДанных.Вставить("ИерархияПодразделений",ТаблицаПодразделений);
	НаборыВнешнихДанных.Вставить("ТаблицаНорм"			,ТаблицаНорм);
	
	//Инициализировать(<Макет>, <ВнешниеНаборыДанных>, <ДанныеРасшифровки>, <ВозможностьИспользованияВнешнихФункций>) 
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки,НаборыВнешнихДанных , ДанныеРасшифровки);
	
	ДокументРезультат.Очистить();
	
	// Выводим результат в табличный документ
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);	
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);

	
КонецПроцедуры

Процедура ДополнитьТаблицу(ТаблицаИсточник, ТаблицаПриемник, Подразделение) 
	
	Для Каждого СтрокаТаблицыИсточник Из ТаблицаИсточник Цикл
		
		СтрокаТаблицыПриемника = ТаблицаПриемник.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицыПриемника, СтрокаТаблицыИсточник);
		СтрокаТаблицыПриемника.Подразделение = Подразделение;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьТаблицуНормПодразделения(ДатаАнализа,Организация,Подразделение = Неопределено)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ разрешенные
				   |	ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка) как СлужебнаяКолонка,
	               |	УстановленныеНормыВыдачиСИЗСрезПоследних.Организация,
	               |	УстановленныеНормыВыдачиСИЗСрезПоследних.Подразделение,
	               |	УстановленныеНормыВыдачиСИЗСрезПоследних.Должность,
	               |	УстановленныеНормыВыдачиСИЗСрезПоследних.РабочееМесто,
	               |	УстановленныеНормыВыдачиСИЗСрезПоследних.УсловиеНормы,
	               |	УстановленныеНормыВыдачиСИЗСрезПоследних.НормаВыдачи,
	               |	НормыВыдачиСИЗСоставНормы.НоменклатураНормы,
	               |	НормыВыдачиСИЗСоставНормы.ЕдиницаИзмерения,
	               |	НормыВыдачиСИЗСоставНормы.ПериодичностьВыдачи,
	               |	НормыВыдачиСИЗСоставНормы.ГОСТ
	               |ИЗ
	               |	РегистрСведений.УстановленныеНормыВыдачиСИЗ.СрезПоследних(
	               |			&ДатаАнализа,
	               |			Организация = &Организация
	               |				"+?(не Подразделение = Неопределено,"И Подразделение = &Подразделение","")+") КАК УстановленныеНормыВыдачиСИЗСрезПоследних
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НормыВыдачиСИЗ.СоставНормы КАК НормыВыдачиСИЗСоставНормы
	               |		ПО УстановленныеНормыВыдачиСИЗСрезПоследних.НормаВыдачи = НормыВыдачиСИЗСоставНормы.Ссылка
				   |	ГДЕ
				   |		УстановленныеНормыВыдачиСИЗСрезПоследних.Использовать = ИСТИНА";
				   
	Запрос.УстановитьПараметр("ДатаАнализа",ДатаАнализа);
	Запрос.УстановитьПараметр("Организация",Организация);
	Запрос.УстановитьПараметр("Подразделение",Подразделение);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции	

//+++АСТБ_Горюшин_Алексей_54520
Процедура ДобавлениеУточненныхОснованийНорм(ТаблицаНорм)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаНорм.ГОСТ КАК ГОСТ,
	|	ТаблицаНорм.Должность КАК Должность,
	|	ТаблицаНорм.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ТаблицаНорм.НоменклатураНормы КАК НоменклатураНормы,
	|	ТаблицаНорм.НормаВыдачи КАК НормаВыдачи,
	|	ТаблицаНорм.Организация КАК Организация,
	|	ТаблицаНорм.ПериодичностьВыдачи КАК ПериодичностьВыдачи,
	|	ТаблицаНорм.Подразделение КАК Подразделение,
	|	ТаблицаНорм.РабочееМесто КАК РабочееМесто,
	|	ТаблицаНорм.УсловиеНормы КАК УсловиеНормы
	|ПОМЕСТИТЬ ВТ_ТаблицаНорм
	|ИЗ
	|	&ТаблицаНорм КАК ТаблицаНорм
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УточненныеОснованияНормВыдачи.Организация КАК Организация,
	|	УточненныеОснованияНормВыдачи.НормаВыдачи КАК НормаВыдачи,
	|	УточненныеОснованияНормВыдачи.Подразделение КАК Подразделение,
	|	УточненныеОснованияНормВыдачи.Должность КАК Должность,
	|	УточненныеОснованияНормВыдачи.РабочееМесто КАК РабочееМесто,
	|	УточненныеОснованияНормВыдачи.Основание КАК Основание
	|ПОМЕСТИТЬ ВТ_УОНВ_Организация_Подразделение_Должность_РабочееМесто
	|ИЗ
	|	РегистрСведений.УточненныеОснованияНормВыдачи КАК УточненныеОснованияНормВыдачи
	|ГДЕ
	|	НЕ УточненныеОснованияНормВыдачи.Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
	|	И НЕ УточненныеОснованияНормВыдачи.Должность = ЗНАЧЕНИЕ(Справочник.ДолжностиИПрофессии.ПустаяСсылка)
	|	И НЕ УточненныеОснованияНормВыдачи.РабочееМесто = ЗНАЧЕНИЕ(Справочник.РабочиеМестаАСТБ.ПустаяСсылка)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	НормаВыдачи,
	|	Подразделение,
	|	Должность,
	|	РабочееМесто
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УточненныеОснованияНормВыдачи.Организация КАК Организация,
	|	УточненныеОснованияНормВыдачи.НормаВыдачи КАК НормаВыдачи,
	|	УточненныеОснованияНормВыдачи.Подразделение КАК Подразделение,
	|	УточненныеОснованияНормВыдачи.Должность КАК Должность,
	|	УточненныеОснованияНормВыдачи.РабочееМесто КАК РабочееМесто,
	|	УточненныеОснованияНормВыдачи.Основание КАК Основание
	|ПОМЕСТИТЬ ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_РабочееМесто
	|ИЗ
	|	РегистрСведений.УточненныеОснованияНормВыдачи КАК УточненныеОснованияНормВыдачи
	|ГДЕ
	|	УточненныеОснованияНормВыдачи.Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
	|	И НЕ УточненныеОснованияНормВыдачи.Должность = ЗНАЧЕНИЕ(Справочник.ДолжностиИПрофессии.ПустаяСсылка)
	|	И НЕ УточненныеОснованияНормВыдачи.РабочееМесто = ЗНАЧЕНИЕ(Справочник.РабочиеМестаАСТБ.ПустаяСсылка)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	НормаВыдачи,
	|	Подразделение,
	|	Должность,
	|	РабочееМесто
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УточненныеОснованияНормВыдачи.Организация КАК Организация,
	|	УточненныеОснованияНормВыдачи.НормаВыдачи КАК НормаВыдачи,
	|	УточненныеОснованияНормВыдачи.Подразделение КАК Подразделение,
	|	УточненныеОснованияНормВыдачи.Должность КАК Должность,
	|	УточненныеОснованияНормВыдачи.РабочееМесто КАК РабочееМесто,
	|	УточненныеОснованияНормВыдачи.Основание КАК Основание
	|ПОМЕСТИТЬ ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_РабочееМесто
	|ИЗ
	|	РегистрСведений.УточненныеОснованияНормВыдачи КАК УточненныеОснованияНормВыдачи
	|ГДЕ
	|	НЕ УточненныеОснованияНормВыдачи.Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
	|	И УточненныеОснованияНормВыдачи.Должность = ЗНАЧЕНИЕ(Справочник.ДолжностиИПрофессии.ПустаяСсылка)
	|	И НЕ УточненныеОснованияНормВыдачи.РабочееМесто = ЗНАЧЕНИЕ(Справочник.РабочиеМестаАСТБ.ПустаяСсылка)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	НормаВыдачи,
	|	Подразделение,
	|	Должность,
	|	РабочееМесто
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УточненныеОснованияНормВыдачи.Организация КАК Организация,
	|	УточненныеОснованияНормВыдачи.НормаВыдачи КАК НормаВыдачи,
	|	УточненныеОснованияНормВыдачи.Подразделение КАК Подразделение,
	|	УточненныеОснованияНормВыдачи.Должность КАК Должность,
	|	УточненныеОснованияНормВыдачи.РабочееМесто КАК РабочееМесто,
	|	УточненныеОснованияНормВыдачи.Основание КАК Основание
	|ПОМЕСТИТЬ ВТ_УОНВ_Организация_Подразделение_Должность_ПустоеРабочееМесто
	|ИЗ
	|	РегистрСведений.УточненныеОснованияНормВыдачи КАК УточненныеОснованияНормВыдачи
	|ГДЕ
	|	НЕ УточненныеОснованияНормВыдачи.Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
	|	И НЕ УточненныеОснованияНормВыдачи.Должность = ЗНАЧЕНИЕ(Справочник.ДолжностиИПрофессии.ПустаяСсылка)
	|	И УточненныеОснованияНормВыдачи.РабочееМесто = ЗНАЧЕНИЕ(Справочник.РабочиеМестаАСТБ.ПустаяСсылка)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	НормаВыдачи,
	|	Подразделение,
	|	Должность,
	|	РабочееМесто
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УточненныеОснованияНормВыдачи.Организация КАК Организация,
	|	УточненныеОснованияНормВыдачи.НормаВыдачи КАК НормаВыдачи,
	|	УточненныеОснованияНормВыдачи.Подразделение КАК Подразделение,
	|	УточненныеОснованияНормВыдачи.Должность КАК Должность,
	|	УточненныеОснованияНормВыдачи.РабочееМесто КАК РабочееМесто,
	|	УточненныеОснованияНормВыдачи.Основание КАК Основание
	|ПОМЕСТИТЬ ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_ПустоеРабочееМесто
	|ИЗ
	|	РегистрСведений.УточненныеОснованияНормВыдачи КАК УточненныеОснованияНормВыдачи
	|ГДЕ
	|	УточненныеОснованияНормВыдачи.Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
	|	И НЕ УточненныеОснованияНормВыдачи.Должность = ЗНАЧЕНИЕ(Справочник.ДолжностиИПрофессии.ПустаяСсылка)
	|	И УточненныеОснованияНормВыдачи.РабочееМесто = ЗНАЧЕНИЕ(Справочник.РабочиеМестаАСТБ.ПустаяСсылка)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	НормаВыдачи,
	|	Подразделение,
	|	Должность,
	|	РабочееМесто
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УточненныеОснованияНормВыдачи.Организация КАК Организация,
	|	УточненныеОснованияНормВыдачи.НормаВыдачи КАК НормаВыдачи,
	|	УточненныеОснованияНормВыдачи.Подразделение КАК Подразделение,
	|	УточненныеОснованияНормВыдачи.Должность КАК Должность,
	|	УточненныеОснованияНормВыдачи.РабочееМесто КАК РабочееМесто,
	|	УточненныеОснованияНормВыдачи.Основание КАК Основание
	|ПОМЕСТИТЬ ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_ПустоеРабочееМесто
	|ИЗ
	|	РегистрСведений.УточненныеОснованияНормВыдачи КАК УточненныеОснованияНормВыдачи
	|ГДЕ
	|	НЕ УточненныеОснованияНормВыдачи.Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
	|	И УточненныеОснованияНормВыдачи.Должность = ЗНАЧЕНИЕ(Справочник.ДолжностиИПрофессии.ПустаяСсылка)
	|	И УточненныеОснованияНормВыдачи.РабочееМесто = ЗНАЧЕНИЕ(Справочник.РабочиеМестаАСТБ.ПустаяСсылка)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	НормаВыдачи,
	|	Подразделение,
	|	Должность,
	|	РабочееМесто
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УточненныеОснованияНормВыдачи.Организация КАК Организация,
	|	УточненныеОснованияНормВыдачи.НормаВыдачи КАК НормаВыдачи,
	|	УточненныеОснованияНормВыдачи.Подразделение КАК Подразделение,
	|	УточненныеОснованияНормВыдачи.Должность КАК Должность,
	|	УточненныеОснованияНормВыдачи.РабочееМесто КАК РабочееМесто,
	|	УточненныеОснованияНормВыдачи.Основание КАК Основание
	|ПОМЕСТИТЬ ВТ_УОНВ_Организация_ПустоеПодразделение_ПустаяДолжность_ПустоеРабочееМесто
	|ИЗ
	|	РегистрСведений.УточненныеОснованияНормВыдачи КАК УточненныеОснованияНормВыдачи
	|ГДЕ
	|	УточненныеОснованияНормВыдачи.Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
	|	И УточненныеОснованияНормВыдачи.Должность = ЗНАЧЕНИЕ(Справочник.ДолжностиИПрофессии.ПустаяСсылка)
	|	И УточненныеОснованияНормВыдачи.РабочееМесто = ЗНАЧЕНИЕ(Справочник.РабочиеМестаАСТБ.ПустаяСсылка)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	НормаВыдачи,
	|	Подразделение,
	|	Должность,
	|	РабочееМесто
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ТаблицаНорм.ГОСТ КАК ГОСТ,
	|	ВТ_ТаблицаНорм.Должность КАК Должность,
	|	ВТ_ТаблицаНорм.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ВТ_ТаблицаНорм.НоменклатураНормы КАК НоменклатураНормы,
	|	ВТ_ТаблицаНорм.НормаВыдачи КАК НормаВыдачи,
	|	ВТ_ТаблицаНорм.Организация КАК Организация,
	|	ВТ_ТаблицаНорм.ПериодичностьВыдачи КАК ПериодичностьВыдачи,
	|	ВТ_ТаблицаНорм.Подразделение КАК Подразделение,
	|	ВТ_ТаблицаНорм.РабочееМесто КАК РабочееМесто,
	|	ВТ_ТаблицаНорм.УсловиеНормы КАК УсловиеНормы,
	|	ВЫБОР
	|		КОГДА ВТ_УОНВ_Организация_Подразделение_Должность_РабочееМесто.Основание ЕСТЬ NULL
	|			ТОГДА ВЫБОР
	|					КОГДА ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_РабочееМесто.Основание ЕСТЬ NULL
	|						ТОГДА ВЫБОР
	|								КОГДА ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_РабочееМесто.Основание ЕСТЬ NULL
	|									ТОГДА ВЫБОР
	|											КОГДА ВТ_УОНВ_Организация_Подразделение_Должность_ПустоеРабочееМесто.Основание ЕСТЬ NULL
	|												ТОГДА ВЫБОР
	|														КОГДА ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_ПустоеРабочееМесто.Основание ЕСТЬ NULL
	|															ТОГДА ВЫБОР
	|																	КОГДА ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_ПустоеРабочееМесто.Основание ЕСТЬ NULL
	|																		ТОГДА ВЫБОР
	|																				КОГДА ВТ_УОНВ_Организация_ПустоеПодразделение_ПустаяДолжность_ПустоеРабочееМесто.Основание ЕСТЬ NULL
	|																					ТОГДА """"
	|																				ИНАЧЕ ВТ_УОНВ_Организация_ПустоеПодразделение_ПустаяДолжность_ПустоеРабочееМесто.Основание
	|																			КОНЕЦ
	|																	ИНАЧЕ ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_ПустоеРабочееМесто.Основание
	|																КОНЕЦ
	|														ИНАЧЕ ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_ПустоеРабочееМесто.Основание
	|													КОНЕЦ
	|											ИНАЧЕ ВТ_УОНВ_Организация_Подразделение_Должность_ПустоеРабочееМесто.Основание
	|										КОНЕЦ
	|								ИНАЧЕ ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_РабочееМесто.Основание
	|							КОНЕЦ
	|					ИНАЧЕ ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_РабочееМесто.Основание
	|				КОНЕЦ
	|		ИНАЧЕ ВТ_УОНВ_Организация_Подразделение_Должность_РабочееМесто.Основание
	|	КОНЕЦ КАК Основание
	|ИЗ
	|	ВТ_ТаблицаНорм КАК ВТ_ТаблицаНорм
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_УОНВ_Организация_Подразделение_Должность_РабочееМесто КАК ВТ_УОНВ_Организация_Подразделение_Должность_РабочееМесто
	|		ПО ВТ_ТаблицаНорм.Подразделение = ВТ_УОНВ_Организация_Подразделение_Должность_РабочееМесто.Подразделение
	|			И ВТ_ТаблицаНорм.НормаВыдачи = ВТ_УОНВ_Организация_Подразделение_Должность_РабочееМесто.НормаВыдачи
	|			И ВТ_ТаблицаНорм.Должность = ВТ_УОНВ_Организация_Подразделение_Должность_РабочееМесто.Должность
	|			И ВТ_ТаблицаНорм.РабочееМесто = ВТ_УОНВ_Организация_Подразделение_Должность_РабочееМесто.РабочееМесто
	|			И ВТ_ТаблицаНорм.Организация = ВТ_УОНВ_Организация_Подразделение_Должность_РабочееМесто.Организация
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_РабочееМесто КАК ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_РабочееМесто
	|		ПО ВТ_ТаблицаНорм.НормаВыдачи = ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_РабочееМесто.НормаВыдачи
	|			И ВТ_ТаблицаНорм.Должность = ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_РабочееМесто.Должность
	|			И ВТ_ТаблицаНорм.РабочееМесто = ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_РабочееМесто.РабочееМесто
	|			И ВТ_ТаблицаНорм.Организация = ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_РабочееМесто.Организация
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_РабочееМесто КАК ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_РабочееМесто
	|		ПО ВТ_ТаблицаНорм.НормаВыдачи = ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_РабочееМесто.НормаВыдачи
	|			И ВТ_ТаблицаНорм.Подразделение = ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_РабочееМесто.Подразделение
	|			И ВТ_ТаблицаНорм.РабочееМесто = ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_РабочееМесто.РабочееМесто
	|			И ВТ_ТаблицаНорм.Организация = ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_РабочееМесто.Организация
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_УОНВ_Организация_Подразделение_Должность_ПустоеРабочееМесто КАК ВТ_УОНВ_Организация_Подразделение_Должность_ПустоеРабочееМесто
	|		ПО ВТ_ТаблицаНорм.Подразделение = ВТ_УОНВ_Организация_Подразделение_Должность_ПустоеРабочееМесто.Подразделение
	|			И ВТ_ТаблицаНорм.НормаВыдачи = ВТ_УОНВ_Организация_Подразделение_Должность_ПустоеРабочееМесто.НормаВыдачи
	|			И ВТ_ТаблицаНорм.Должность = ВТ_УОНВ_Организация_Подразделение_Должность_ПустоеРабочееМесто.Должность
	|			И ВТ_ТаблицаНорм.Организация = ВТ_УОНВ_Организация_Подразделение_Должность_ПустоеРабочееМесто.Организация
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_ПустоеРабочееМесто КАК ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_ПустоеРабочееМесто
	|		ПО ВТ_ТаблицаНорм.НормаВыдачи = ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_ПустоеРабочееМесто.НормаВыдачи
	|			И ВТ_ТаблицаНорм.Должность = ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_ПустоеРабочееМесто.Должность
	|			И ВТ_ТаблицаНорм.Организация = ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_ПустоеРабочееМесто.Организация
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_ПустоеРабочееМесто КАК ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_ПустоеРабочееМесто
	|		ПО ВТ_ТаблицаНорм.НормаВыдачи = ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_ПустоеРабочееМесто.НормаВыдачи
	|			И ВТ_ТаблицаНорм.Подразделение = ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_ПустоеРабочееМесто.Подразделение
	|			И ВТ_ТаблицаНорм.Организация = ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_ПустоеРабочееМесто.Организация
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_УОНВ_Организация_ПустоеПодразделение_ПустаяДолжность_ПустоеРабочееМесто КАК ВТ_УОНВ_Организация_ПустоеПодразделение_ПустаяДолжность_ПустоеРабочееМесто
	|		ПО ВТ_ТаблицаНорм.НормаВыдачи = ВТ_УОНВ_Организация_ПустоеПодразделение_ПустаяДолжность_ПустоеРабочееМесто.НормаВыдачи
	|			И ВТ_ТаблицаНорм.Организация = ВТ_УОНВ_Организация_ПустоеПодразделение_ПустаяДолжность_ПустоеРабочееМесто.Организация";
	
	Запрос.УстановитьПараметр("ТаблицаНорм", ТаблицаНорм);
	
	ТаблицаНорм = Запрос.Выполнить().Выгрузить();	
	
КонецПроцедуры //---АСТБ_Горюшин_Алексей_54520
