module Erp
  class UserGroup < ApplicationRecord
    validates :name, presence: true
    has_many :users
    belongs_to :creator, class_name: "Erp::User"

    # Filters
    def self.filter(query, params)
      params = params.to_unsafe_hash
      and_conds = []

      #keywords
      if params["keywords"].present?
        params["keywords"].each do |kw|
          or_conds = []
          kw[1].each do |cond|
            or_conds << "LOWER(#{cond[1]["name"]}) LIKE '%#{cond[1]["value"].downcase.strip}%'"
          end
          and_conds << '('+or_conds.join(' OR ')+')'
        end
      end

      query = query.where(and_conds.join(' AND ')) if !and_conds.empty?

      return query
    end

    def self.search(params)
      query = self.order("created_at DESC")
      query = self.filter(query, params)

      return query
    end

    # data for dataselect ajax
    def self.dataselect(keyword='')
      query = self.all

      if keyword.present?
        keyword = keyword.strip.downcase
        query = query.where('LOWER(name) LIKE ?', "%#{keyword}%")
      end

      query = query.limit(8).map{|user_group| {value: user_group.id, text: user_group.name} }
    end
    
    # activate
    def activate
			update_columns(active: true)
		end
    
    # deactivate
    def deactivate
			update_columns(active: false)
		end

    # update permissions
    def update_permissions(permissions_params)
      self.update_column(:permissions, permissions_params.to_json)
    end

    # get permissions
    def get_permissions
      permissions = UserGroup.permissions_array
      saved_permissions = self.permissions.present? ? JSON.parse(self.permissions) : {}

      permissions.each do |h_group|
        h_group[1].each do |h_engine|
          h_engine[1].each do |h_controller|
            h_controller[1].each do |h_permission|
              if saved_permissions[h_group[0].to_s].present? and
                saved_permissions[h_group[0].to_s][h_engine[0].to_s].present? and
                saved_permissions[h_group[0].to_s][h_engine[0].to_s][h_controller[0].to_s].present?
                saved_permissions[h_group[0].to_s][h_engine[0].to_s][h_controller[0].to_s][h_permission[0].to_s].present? and
                  permissions[h_group[0]][h_engine[0]][h_controller[0]][h_permission[0]][:value] = saved_permissions[h_group[0].to_s][h_engine[0].to_s][h_controller[0].to_s][h_permission[0].to_s]['value']
              end
            end
          end
        end
      end

      permissions
    end

    # Permission array
    def self.permissions_array
      arr = {
        # Inventory
        inventory: {
          order_stock_checks: {
            schecks: {
              check: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              approve_order: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            }
          },
          qdeliveries: {
            deliveries: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              sales_orders: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              purchase_orders: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            }
          },
          stock_transfers: {
            transfers: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              check_transfer: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            }
          },
          products: {
            warehouse_checks: {
              state_check: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              stock_check: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              damage_check: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            },
            products: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            },
            warehouses: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            },
            states: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            },
            categories: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            },
            properties: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            },
            manufacturers: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            },
          },
        },
        sales: {
          sales: {
            orders: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            },
          },
          gift_givens: {
            gift_givens: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            }
          },
          consignments: {
            consignments: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              return: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            }
          },
          prices: {
            customer_prices: {
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              update_general: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            }
          },
        },
        purchase: {
          purchase: {
            orders: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            },
          },
          prices: {
            supplier_prices: {
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              update_general: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            }
          },
          products: {
            stock_import: {
              view: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            },
            areas: {
              side: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              central: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            }
          },
        },
        accounting: {
          payments: {
            payment_records: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            },
            accounts: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            },
            payment_types: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            },
          },
          chase: {
            chase: {
              sales: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              purchase: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              return: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            },
            customer_commision: {
              customer: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              supplier: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            },
            commision: {
              customer: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              employee: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            },
          },
        },
        contacts: {
          contacts: {
            contacts: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            },
          },
        },
        options: {
          users: {
            users: {
              index: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              create: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              update: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            },
            user_groups: {
              index: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              create: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              update: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            },
          },
          targets: {
            targets: {
              index: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              update: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            },
            company_targets: {
              index: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              create: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              update: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            },
          },
          periods: {
            periods: {
              index: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              create: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              update: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            },
          },
        },
        report: {
          report: {
            inventory: {
              matrix: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              delivery: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              delivery_detail: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              category_diameter: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              product: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              central_area: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              custom_area: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              outside_product: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              warehouse: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            },
            sales: {
              sales: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              sales_details: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              returning: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              new_patient: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            },
            accounting: {
              pay_receive_details: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              payment_types: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              sales: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              revenue_report: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              accounts: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              customer_liabilities: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              supplier_liabilities: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              liabilities_arising: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ]
              },
              period_liabilities: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            },
          },
        },
        system: {
          system: {
            system: {
              settings: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              backup: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
              restore: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'C??'},
                  {value: 'no', text: 'Kh??ng'},
                ],
              },
            },
          },
        },
      }

      arr
    end
  end
end
