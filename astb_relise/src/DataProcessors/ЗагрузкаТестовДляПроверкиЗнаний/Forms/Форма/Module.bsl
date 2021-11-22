
&НаКлиенте
Процедура ФайлДанныхНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НастройкиДиалога = Новый Структура;
	НастройкиДиалога.Вставить("Фильтр", НСтр("ru = 'Документ XML(*.xml)|*.xml'"));
	НастройкиДиалога.Вставить("ПроверятьСуществованиеФайла", Истина);
	
	ОбменДаннымиКлиент.ОбработчикВыбораФайла(Объект,"ФайлДанных",СтандартнаяОбработка, НастройкиДиалога);	
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлДанныхОткрытие(Элемент, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ОбработчикОткрытияФайлаИлиКаталога(Объект,"ФайлДанных",СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьФайлНаСервере(АдресВременногоХранилища)
	
	Объект.ТаблицаВопросов.Очистить();
	Объект.ТаблицаОтветов.Очистить();
	Объект.ТаблицаТестов.Очистить();
	
	Объект.ПротоколОшибок = "";
	
	ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	
	ВременныйФайл = ПолучитьИмяВременногоФайла("xml");
	
	ДвоичныеДанныеФайла.Записать(ВременныйФайл);
	
	//чтение данных из макета
	Чтение = Новый ЧтениеXML;
	Чтение.ОткрытьФайл(ВременныйФайл);
	
	Пока Чтение.Прочитать() Цикл
		
		Если Чтение.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
	
			Если Чтение.ЛокальноеИмя = "test_export" Тогда //основной тэг
				
				ФорматЗагрузки = СокрЛП(Чтение.ЗначениеАтрибута("format_version"));
				
				Если НЕ ФорматЗагрузки = "1.0" Тогда
					Объект.ПротоколОшибок = "Неверный формат файла: " + ФорматЗагрузки + Символы.ПС;
				КонецЕсли;
				
				Если СтрДлина(Объект.ПротоколОшибок) > 0 Тогда //дальше бежать смысла нет!
					Возврат;
				КонецЕсли;
				
			КонецЕсли;
			
			//тест
			Если Чтение.ЛокальноеИмя = "test_item" Тогда
				
				Ошибка = Ложь;
				
				Если Чтение.ЗначениеАтрибута("test_group_name") = Неопределено Тогда
					Если СтрНайти(Объект.ПротоколОшибок,"Отсутствует атрибут <<test_group_name>>") = 0 Тогда
				    	Объект.ПротоколОшибок = Объект.ПротоколОшибок + "Отсутствует атрибут <<test_group_name>>" + Символы.ПС;
					КонецЕсли;	
					НаименованиеГруппы = "";
					Ошибка = Истина;
				Иначе
					НаименованиеГруппы = СокрЛП(Чтение.ЗначениеАтрибута("test_group_name"));
					Если НЕ ЗначениеЗаполнено(НаименованиеГруппы) Тогда
						Если СтрНайти(Объект.ПротоколОшибок,"Не заполнен атрибут <<test_group_name>>") = 0 Тогда
							Объект.ПротоколОшибок = Объект.ПротоколОшибок + "Не заполнен атрибут <<test_group_name>>" + Символы.ПС;
						КонецЕсли;
						Ошибка = Истина;
					КонецЕсли;	
				КонецЕсли; 
				
				Если Чтение.ЗначениеАтрибута("test_name") = Неопределено Тогда
					Если СтрНайти(Объект.ПротоколОшибок,"Отсутствует атрибут <<test_name>>") = 0 Тогда
				    	Объект.ПротоколОшибок = Объект.ПротоколОшибок + "Отсутствует атрибут <<test_name>>" + Символы.ПС;
					КонецЕсли;	
					НаименованиеТеста = "";
					Ошибка = Истина;
				Иначе
					НаименованиеТеста = СокрЛП(Чтение.ЗначениеАтрибута("test_name"));
					Если НЕ ЗначениеЗаполнено(НаименованиеТеста) Тогда
						Если СтрНайти(Объект.ПротоколОшибок,"Не заполнен атрибут <<test_name>>") = 0 Тогда
							Объект.ПротоколОшибок = Объект.ПротоколОшибок + "Не заполнен атрибут <<test_name>>" + Символы.ПС;
						КонецЕсли;
						Ошибка = Истина;
					КонецЕсли;	
				КонецЕсли;
				
				Если Чтение.ЗначениеАтрибута("test_description") = Неопределено Тогда
					Если СтрНайти(Объект.ПротоколОшибок,"Отсутствует атрибут <<test_description>>") = 0 Тогда
				    	Объект.ПротоколОшибок = Объект.ПротоколОшибок + "Отсутствует атрибут <<test_description>>" + Символы.ПС;
					КонецЕсли;	
					СодержаниеТеста = "";
					Ошибка = Истина;
				Иначе
					СодержаниеТеста = СокрЛП(Чтение.ЗначениеАтрибута("test_description"));
					Если НЕ ЗначениеЗаполнено(СодержаниеТеста) Тогда
						Если СтрНайти(Объект.ПротоколОшибок,"Не заполнен атрибут <<test_description>>") = 0 Тогда
							Объект.ПротоколОшибок = Объект.ПротоколОшибок + "Не заполнен атрибут <<test_description>>" + Символы.ПС;
						КонецЕсли;
						Ошибка = Истина;
					КонецЕсли;	
				КонецЕсли;
				
				НоваяСтрока 					= ОБъект.ТаблицаТестов.Добавить();
				НоваяСтрока.test_group_name 	= НаименованиеГруппы;
				НоваяСтрока.test_name 			= НаименованиеТеста;
				НоваяСтрока.test_description 	= СодержаниеТеста;
				НоваяСтрока.Ошибка				= Ошибка;
				
			КонецЕсли;
			
			//вопрос
			Если Чтение.ЛокальноеИмя = "question_item" Тогда
				
				Ошибка = Ложь;
				
				Если Чтение.ЗначениеАтрибута("question_name") = Неопределено Тогда
					Если СтрНайти(Объект.ПротоколОшибок,"Отсутствует атрибут <<question_name>>") = 0 Тогда
				    	Объект.ПротоколОшибок = Объект.ПротоколОшибок + "Отсутствует атрибут <<question_name>>" + Символы.ПС;
					КонецЕсли;	
					НаименованиеВопроса = "";
					Ошибка = Истина;
				Иначе
					НаименованиеВопроса = СокрЛП(Чтение.ЗначениеАтрибута("question_name"));
					Если НЕ ЗначениеЗаполнено(НаименованиеВопроса) Тогда
						Если СтрНайти(Объект.ПротоколОшибок,"Не заполнен атрибут <<question_name>>") = 0 Тогда
							Объект.ПротоколОшибок = Объект.ПротоколОшибок + "Не заполнен атрибут <<question_name>>" + Символы.ПС;
						КонецЕсли;
						Ошибка = Истина;
					КонецЕсли;	
				КонецЕсли;
				
				Если Чтение.ЗначениеАтрибута("question_description") = Неопределено Тогда
					Если СтрНайти(Объект.ПротоколОшибок,"Отсутствует атрибут <<question_description>>") = 0 Тогда
				    	Объект.ПротоколОшибок = Объект.ПротоколОшибок + "Отсутствует атрибут <<question_description>>" + Символы.ПС;
					КонецЕсли;	
					СодержаниеВопроса = "";
					Ошибка = Истина;
				Иначе
					СодержаниеВопроса = СокрЛП(Чтение.ЗначениеАтрибута("question_description"));
					Если НЕ ЗначениеЗаполнено(СодержаниеВопроса) Тогда
						Если СтрНайти(Объект.ПротоколОшибок,"Не заполнен атрибут <<question_description>>") = 0 Тогда
							Объект.ПротоколОшибок = Объект.ПротоколОшибок + "Не заполнен атрибут <<question_description>>" + Символы.ПС;
						КонецЕсли;
						Ошибка = Истина;
					КонецЕсли;	
				КонецЕсли;
				
				НоваяСтрока 						= Объект.ТаблицаВопросов.Добавить();
				НоваяСтрока.test_name 				= НаименованиеТеста;
				НоваяСтрока.question_name 			= НаименованиеВопроса;
				НоваяСтрока.question_description 	= СодержаниеВопроса;
				НоваяСтрока.Ошибка					= Ошибка;
				
			КонецЕсли;
			
			//ответ
			Если Чтение.ЛокальноеИмя = "answer_item" Тогда
				
				Ошибка = Ложь;
				
				Если Чтение.ЗначениеАтрибута("answer_name") = Неопределено Тогда
					Если СтрНайти(Объект.ПротоколОшибок,"Отсутствует атрибут <<answer_name>>") = 0 Тогда
				    	Объект.ПротоколОшибок = Объект.ПротоколОшибок + "Отсутствует атрибут <<answer_name>>" + Символы.ПС;
					КонецЕсли;	
					НаименованиеОтвета = "";
					Ошибка = Истина;
				Иначе
					НаименованиеОтвета = СокрЛП(Чтение.ЗначениеАтрибута("answer_name"));
					Если НЕ ЗначениеЗаполнено(НаименованиеОтвета) Тогда
						Если СтрНайти(Объект.ПротоколОшибок,"Не заполнен атрибут <<answer_name>>") = 0 Тогда
							Объект.ПротоколОшибок = Объект.ПротоколОшибок + "Не заполнен атрибут <<answer_name>>" + Символы.ПС;
						КонецЕсли;
						Ошибка = Истина;
					КонецЕсли;	
				КонецЕсли; 
				
				Если Чтение.ЗначениеАтрибута("answer_description") = Неопределено Тогда
					Если СтрНайти(Объект.ПротоколОшибок,"Отсутствует атрибут <<answer_description>>") = 0 Тогда
				    	Объект.ПротоколОшибок = Объект.ПротоколОшибок + "Отсутствует атрибут <<answer_description>>" + Символы.ПС;
					КонецЕсли;	
					СодержаниеОтвета = "";
					Ошибка = Истина;
				Иначе
					СодержаниеОтвета = СокрЛП(Чтение.ЗначениеАтрибута("answer_description"));
					Если НЕ ЗначениеЗаполнено(СодержаниеОтвета) Тогда
						Если СтрНайти(Объект.ПротоколОшибок,"Не заполнен атрибут <<answer_description>>") = 0 Тогда
							Объект.ПротоколОшибок = Объект.ПротоколОшибок + "Не заполнен атрибут <<answer_description>>" + Символы.ПС;
						КонецЕсли;
						Ошибка = Истина;
					КонецЕсли;	
				КонецЕсли;
				
				Если Чтение.ЗначениеАтрибута("answer_correct") = Неопределено Тогда
					Если СтрНайти(Объект.ПротоколОшибок,"Отсутствует атрибут <<answer_correct>>") = 0 Тогда
				    	Объект.ПротоколОшибок = Объект.ПротоколОшибок + "Отсутствует атрибут <<answer_correct>>" + Символы.ПС;
					КонецЕсли;	
					ОтветПравильный = Ложь;
					Ошибка = Истина;
				Иначе
					ОтветПравильный = ?(СокрЛП(Чтение.ЗначениеАтрибута("answer_correct")) = "0",Ложь,Истина);
					Если НЕ ЗначениеЗаполнено(СокрЛП(Чтение.ЗначениеАтрибута("answer_correct"))) Тогда
						Если СтрНайти(Объект.ПротоколОшибок,"Не заполнен атрибут <<answer_correct>>") = 0 Тогда
							Объект.ПротоколОшибок = Объект.ПротоколОшибок + "Не заполнен атрибут <<answer_correct>>" + Символы.ПС;
						КонецЕсли;
						ОтветПравильный = Ложь;
						Ошибка = Истина;
					КонецЕсли;	
				КонецЕсли;
				
				НоваяСтрока 					= ОБъект.ТаблицаОтветов.Добавить();
				НоваяСтрока.test_name 			= НаименованиеТеста;
				НоваяСтрока.question_name 		= НаименованиеВопроса;
				НоваяСтрока.answer_name 		= НаименованиеОтвета;
				НоваяСтрока.answer_description 	= СодержаниеОтвета;
				НоваяСтрока.answer_correct 		= ОтветПравильный;
				НоваяСтрока.Ошибка				= Ошибка;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
		
	Чтение.Закрыть();

	ПрочитатьДанныеВБазе();
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьДанныеВБазе()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаТестов.test_group_name КАК test_group_name,
	|	ТаблицаТестов.test_name КАК test_name,
	|	ТаблицаТестов.test_description КАК test_description
	|ПОМЕСТИТЬ ВТ_ТаблицаТестов
	|ИЗ
	|	&ТаблицаТестов КАК ТаблицаТестов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВопросов.test_name КАК test_name,
	|	ТаблицаВопросов.question_name КАК question_name,
	|	ТаблицаВопросов.question_description КАК question_description
	|ПОМЕСТИТЬ ВТ_ТаблицаВопросов
	|ИЗ
	|	&ТаблицаВопросов КАК ТаблицаВопросов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОтветов.test_name КАК test_name,
	|	ТаблицаОтветов.question_name КАК question_name,
	|	ТаблицаОтветов.answer_name КАК answer_name,
	|	ТаблицаОтветов.answer_description КАК answer_description,
	|	ТаблицаОтветов.answer_correct КАК answer_correct
	|ПОМЕСТИТЬ ВТ_ТаблицаОтветов
	|ИЗ
	|	&ТаблицаОтветов КАК ТаблицаОтветов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.test_name КАК test_name,
	|	ВложенныйЗапрос.question_name КАК question_name,
	|	ВложенныйЗапрос.question_description КАК question_description,
	|	ВложенныйЗапрос.ГруппаВопросов КАК ГруппаВопросов,
	|	ВопросыДляТестов.Ссылка КАК Вопрос,
	|	Тесты.Ссылка КАК Тест
	|ПОМЕСТИТЬ ВТ_Вопросы
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВТ_ТаблицаВопросов.test_name КАК test_name,
	|		ВТ_ТаблицаВопросов.question_name КАК question_name,
	|		ВТ_ТаблицаВопросов.question_description КАК question_description,
	|		ВопросыДляТестов.Ссылка КАК ГруппаВопросов
	|	ИЗ
	|		ВТ_ТаблицаВопросов КАК ВТ_ТаблицаВопросов
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВопросыДляТестов КАК ВопросыДляТестов
	|			ПО ВТ_ТаблицаВопросов.test_name = ВопросыДляТестов.Наименование
	|	ГДЕ
	|		(ВопросыДляТестов.Ссылка ЕСТЬ NULL
	|				ИЛИ ВопросыДляТестов.ЭтоГруппа)) КАК ВложенныйЗапрос
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВопросыДляТестов КАК ВопросыДляТестов
	|		ПО ВложенныйЗапрос.ГруппаВопросов = ВопросыДляТестов.Родитель
	|			И ВложенныйЗапрос.question_name = ВопросыДляТестов.Наименование
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Тесты КАК Тесты
	|		ПО ВложенныйЗапрос.test_name = Тесты.Наименование
	|ГДЕ
	|	(ВопросыДляТестов.Ссылка ЕСТЬ NULL
	|			ИЛИ НЕ ВопросыДляТестов.ЭтоГруппа)
	|	И (Тесты.Ссылка ЕСТЬ NULL
	|			ИЛИ НЕ Тесты.ЭтоГруппа)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.test_group_name КАК test_group_name,
	|	ВложенныйЗапрос.test_name КАК test_name,
	|	ВложенныйЗапрос.test_description КАК test_description,
	|	ВложенныйЗапрос.ГруппаТестов КАК ГруппаТестов,
	|	Тесты.Ссылка КАК Тест
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВТ_ТаблицаТестов.test_group_name КАК test_group_name,
	|		ВТ_ТаблицаТестов.test_name КАК test_name,
	|		ВТ_ТаблицаТестов.test_description КАК test_description,
	|		Тесты.Ссылка КАК ГруппаТестов
	|	ИЗ
	|		ВТ_ТаблицаТестов КАК ВТ_ТаблицаТестов
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Тесты КАК Тесты
	|			ПО ВТ_ТаблицаТестов.test_group_name = Тесты.Наименование
	|	ГДЕ
	|		(Тесты.Ссылка ЕСТЬ NULL
	|				ИЛИ Тесты.ЭтоГруппа)) КАК ВложенныйЗапрос
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Тесты КАК Тесты
	|		ПО ВложенныйЗапрос.ГруппаТестов = Тесты.Родитель
	|			И ВложенныйЗапрос.test_name = Тесты.Наименование
	|ГДЕ
	|	(Тесты.Ссылка ЕСТЬ NULL
	|			ИЛИ НЕ Тесты.ЭтоГруппа)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Вопросы.test_name КАК test_name,
	|	ВТ_Вопросы.question_name КАК question_name,
	|	ВТ_Вопросы.question_description КАК question_description,
	|	ВТ_Вопросы.ГруппаВопросов КАК ГруппаВопросов,
	|	ВТ_Вопросы.Вопрос КАК Вопрос,
	|	ВТ_Вопросы.Тест КАК Тест
	|ИЗ
	|	ВТ_Вопросы КАК ВТ_Вопросы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.test_name КАК test_name,
	|	ВложенныйЗапрос.question_name КАК question_name,
	|	ВложенныйЗапрос.answer_name КАК answer_name,
	|	ВложенныйЗапрос.answer_description КАК answer_description,
	|	ВложенныйЗапрос.answer_correct КАК answer_correct,
	|	ВложенныйЗапрос.ГруппаОтветов КАК ГруппаОтветов,
	|	Ответы.Ссылка КАК Ответ,
	|	ВТ_Вопросы.Вопрос КАК Вопрос
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВТ_ТаблицаОтветов.test_name КАК test_name,
	|		ВТ_ТаблицаОтветов.question_name КАК question_name,
	|		ВТ_ТаблицаОтветов.answer_name КАК answer_name,
	|		ВТ_ТаблицаОтветов.answer_description КАК answer_description,
	|		ВТ_ТаблицаОтветов.answer_correct КАК answer_correct,
	|		Ответы.Ссылка КАК ГруппаОтветов
	|	ИЗ
	|		ВТ_ТаблицаОтветов КАК ВТ_ТаблицаОтветов
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Ответы КАК Ответы
	|			ПО ВТ_ТаблицаОтветов.question_name = Ответы.Наименование
	|	ГДЕ
	|		(Ответы.Ссылка ЕСТЬ NULL
	|				ИЛИ Ответы.ЭтоГруппа)) КАК ВложенныйЗапрос
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Ответы КАК Ответы
	|		ПО ВложенныйЗапрос.ГруппаОтветов = Ответы.Родитель
	|			И ВложенныйЗапрос.answer_name = Ответы.Наименование
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Вопросы КАК ВТ_Вопросы
	|		ПО ВложенныйЗапрос.test_name = ВТ_Вопросы.test_name
	|			И ВложенныйЗапрос.question_name = ВТ_Вопросы.question_name
	|ГДЕ
	|	(Ответы.Ссылка ЕСТЬ NULL
	|			ИЛИ НЕ Ответы.ЭтоГруппа)";
	
	Запрос.УстановитьПараметр("ТаблицаТестов",	Объект.ТаблицаТестов.Выгрузить());
	Запрос.УстановитьПараметр("ТаблицаВопросов",Объект.ТаблицаВопросов.Выгрузить());
	Запрос.УстановитьПараметр("ТаблицаОтветов",	Объект.ТаблицаОтветов.Выгрузить());
	
	Результат = Запрос.ВыполнитьПакет();
	
	Объект.ТаблицаТестов.Загрузить(Результат[4].Выгрузить());
	Объект.ТаблицаВопросов.Загрузить(Результат[5].Выгрузить());
	Объект.ТаблицаОтветов.Загрузить(Результат[6].Выгрузить());

КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьФайл(Команда)
	
	АдресВременногоХранилища = ПоместитьВоВременноеХранилище(НОВЫЙ ДвоичныеДанные(Объект.ФайлДанных),ЭтаФорма.УникальныйИдентификатор);
	
	ПрочитатьФайлНаСервере(АдресВременногоХранилища);
	
	Если СтрДлина(Объект.ПротоколОшибок) > 0 Тогда  
	    ЭтаФорма.Элементы.Страницы.ТекущаяСтраница = ЭтаФорма.Элементы.Ошибки;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанныеНаСервере()
	
	//1. заполнение справочников
	Для Каждого СтрокаТаблицыТестов Из Объект.ТаблицаТестов Цикл
		
		Если СтрокаТаблицыТестов.Ошибка Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицыТестов.ГруппаТестов) Тогда
			СтрокаТаблицыТестов.ГруппаТестов = ПолучитьГруппуТестов(СтрокаТаблицыТестов);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицыТестов.Тест) Тогда
			СтрокаТаблицыТестов.Тест = ПолучитьТест(СтрокаТаблицыТестов);
		КонецЕсли;
		
	КонецЦикла;	
	
	Для Каждого СтрокаТаблицыВопросов Из Объект.ТаблицаВопросов Цикл
		
		Если СтрокаТаблицыВопросов.Ошибка Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицыВопросов.ГруппаВопросов) Тогда
			СтрокаТаблицыВопросов.ГруппаВопросов = ПолучитьГруппуВопросов(СтрокаТаблицыВопросов);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицыВопросов.Вопрос) Тогда
			СтрокаТаблицыВопросов.Вопрос = ПолучитьВопрос(СтрокаТаблицыВопросов);
		КонецЕсли;		
		
	КонецЦикла;
	
	Для Каждого СтрокаТаблицыОтветов Из Объект.ТаблицаОтветов Цикл
		
		Если СтрокаТаблицыОтветов.Ошибка Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицыОтветов.ГруппаОтветов) Тогда
			СтрокаТаблицыОтветов.ГруппаОтветов = ПолучитьГруппуОтветов(СтрокаТаблицыОтветов);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицыОтветов.Ответ) Тогда
			СтрокаТаблицыОтветов.Ответ = ПолучитьОтвет(СтрокаТаблицыОтветов);
		КонецЕсли;		
		
	КонецЦикла;
	
	//2. обновление данных
	ПрочитатьДанныеВБазе();
	
	//3. заполнение табличных частей
	Для Каждого СтрокаТаблицыТестов Из Объект.ТаблицаТестов Цикл
		
		НайденныеСтроки = Объект.ТаблицаВопросов.НайтиСтроки(НОВЫЙ Структура("Тест",СтрокаТаблицыТестов.Тест));
		
		ТестОбъект = СтрокаТаблицыТестов.Тест.ПолучитьОбъект();
		ТестОбъект.Вопросы.Очистить();
		
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			
			ЗаполнитьЗначенияСвойств(ТестОбъект.Вопросы.Добавить(),НайденнаяСтрока);
			
		КонецЦикла;	
		
		ТестОбъект.Записать();
		
	КонецЦикла;	
	
	Для Каждого СтрокаТаблицыВопросов Из Объект.ТаблицаВопросов Цикл
		
		НайденныеСтроки = Объект.ТаблицаОтветов.НайтиСтроки(Новый Структура("Вопрос",СтрокаТаблицыВопросов.Вопрос));
		
		ВопросОбъект = СтрокаТаблицыВопросов.Вопрос.ПолучитьОбъект();
		ВопросОбъект.ВариантыОтветов.Очистить();
		
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			
			НоваяСтрока 			= ВопросОбъект.ВариантыОтветов.Добавить();
			НоваяСтрока.Ответ 		= НайденнаяСтрока.Ответ;
			НоваяСтрока.Правильный 	= НайденнаяСтрока.answer_correct;
			
		КонецЦикла;	
		
		ВопросОбъект.Записать();
		
	КонецЦикла;	
	
КонецПроцедуры

&НаСервере
Функция ПолучитьГруппуОтветов(СтрокаТаблицыОтветов)
	
	ГруппаОтветов = Справочники.Ответы.НайтиПоНаименованию(СтрокаТаблицыОтветов.question_name);
	
	Если ГруппаОтветов.Пустая() Тогда
		
		НоваяГруппа 				= Справочники.Ответы.СоздатьГруппу();
		НоваяГруппа.Наименование 	= СтрокаТаблицыОтветов.question_name;
		НоваяГруппа.УстановитьНовыйКод();
		НоваяГруппа.Записать();
		
		ГруппаОтветов = НоваяГруппа.Ссылка;
		
	КонецЕсли;
	
	Возврат ГруппаОтветов;
	
КонецФункции	

&НаСервере
Функция ПолучитьОтвет(СтрокаТаблицыОтветов)
	
	НайденныйОтвет = Справочники.Ответы.НайтиПоНаименованию(СтрокаТаблицыОтветов.answer_name,,СтрокаТаблицыОтветов.ГруппаОтветов,);
	
	Если НайденныйОтвет.Пустая() Тогда
		
		НовыйОтвет 					= Справочники.Ответы.СоздатьЭлемент();
		НовыйОтвет.Родитель 		= СтрокаТаблицыОтветов.ГруппаОтветов;
		НовыйОтвет.Наименование 	= СтрокаТаблицыОтветов.answer_name;
		НовыйОтвет.Описание 		= СтрокаТаблицыОтветов.answer_description;
		НовыйОтвет.УстановитьНовыйКод();
		НовыйОтвет.Записать();
		
		НайденныйОтвет = НовыйОтвет.Ссылка;
		
	КонецЕсли;

	Возврат НайденныйОтвет;
	
КонецФункции

&НаСервере
Функция ПолучитьГруппуВопросов(СтрокаТаблицыВопросов)
	
	ГруппаВопросов = Справочники.ВопросыДляТестов.НайтиПоНаименованию(СтрокаТаблицыВопросов.test_name);
	
	Если ГруппаВопросов.Пустая() Тогда
		
		НоваяГруппа 				= Справочники.ВопросыДляТестов.СоздатьГруппу();
		НоваяГруппа.Наименование 	= СтрокаТаблицыВопросов.test_name;
		НоваяГруппа.УстановитьНовыйКод();
		НоваяГруппа.Записать();
		
		ГруппаВопросов = НоваяГруппа.Ссылка;
		
	КонецЕсли;
	
	Возврат ГруппаВопросов;
	
КонецФункции	

&НаСервере
Функция ПолучитьВопрос(СтрокаТаблицыВопросов)
	
	НайденныйВопрос = Справочники.ВопросыДляТестов.НайтиПоНаименованию(СтрокаТаблицыВопросов.question_name,,СтрокаТаблицыВопросов.ГруппаВопросов,);
	
	Если НайденныйВопрос.Пустая() Тогда
		
		НовыйВопрос 				= Справочники.ВопросыДляТестов.СоздатьЭлемент();
		НовыйВопрос.Родитель 		= СтрокаТаблицыВопросов.ГруппаВопросов;
		НовыйВопрос.Наименование 	= СтрокаТаблицыВопросов.question_name;
		НовыйВопрос.Описание 		= СтрокаТаблицыВопросов.question_description;
		НовыйВопрос.УстановитьНовыйКод();
		НовыйВопрос.Записать();
		
		НайденныйВопрос = НовыйВопрос.Ссылка;
		
	КонецЕсли;
	
	Возврат НайденныйВопрос;
	
КонецФункции	

&НаСервере
Функция ПолучитьГруппуТестов(СтрокаТаблицыТестов)
	
	ГруппаТестов = Справочники.Тесты.НайтиПоНаименованию(СтрокаТаблицыТестов.test_group_name);
	
	Если ГруппаТестов.Пустая() Тогда
		
		НоваяГруппа 				= Справочники.Тесты.СоздатьГруппу();
		НоваяГруппа.Наименование 	= СтрокаТаблицыТестов.test_group_name;
		НоваяГруппа.УстановитьНовыйКод();
		НоваяГруппа.Записать();
		
		ГруппаТестов = НоваяГруппа.Ссылка;
		
	КонецЕсли;
	
	Возврат ГруппаТестов;
	
КонецФункции	

&НаСервере
Функция ПолучитьТест(СтрокаТаблицыТестов)
	
	НайденныйТест = Справочники.Тесты.НайтиПоНаименованию(СтрокаТаблицыТестов.test_name,,СтрокаТаблицыТестов.ГруппаТестов,);
	
	Если НайденныйТест.Пустая() Тогда
		
		НовыйТест 				= Справочники.Тесты.СоздатьЭлемент();
		НовыйТест.Родитель 		= СтрокаТаблицыТестов.ГруппаТестов;
		НовыйТест.Наименование 	= СтрокаТаблицыТестов.test_name;
		НовыйТест.Описание 		= СтрокаТаблицыТестов.test_description;
		НовыйТест.УстановитьНовыйКод();
		НовыйТест.Записать();
		
		НайденныйТест = НовыйТест.Ссылка;
		
	КонецЕсли;
	
	Возврат НайденныйТест;
	
КонецФункции

&НаКлиенте
Процедура ЗагрузитьДанные(Команда)
	
	ЗагрузитьДанныеНаСервере();
	
	Если СтрДлина(Объект.ПротоколОшибок) > 0 Тогда  
	    ЭтаФорма.Элементы.Страницы.ТекущаяСтраница = ЭтаФорма.Элементы.Ошибки;
	КонецЕсли;
	
КонецПроцедуры
